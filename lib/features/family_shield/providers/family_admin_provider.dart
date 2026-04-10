import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import '../models/family_member.dart';
import '../models/alert_item.dart';
import '../models/qr_payload.dart';
import '../../../data/models/risk_level.dart';
import '../../../core/services/notification_service.dart';

class FamilyAdminProvider extends ChangeNotifier {
  final List<FamilyMember> _members = [];
  String? _localIp;
  int _port = 8080;
  HttpServer? _server;
  String _familyId = 'FAM-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  bool _isServerRunning = false;
  bool _lowScoreNotificationSent = false;

  List<FamilyMember> get members => _members;
  int get totalMembers => _members.length;
  int get membersAtRisk => _members.where((m) => m.safetyStatus != RiskLevel.safe).length;
  int get familyCyberScore {
    if (_members.isEmpty) return 100;
    int totalScore = _members.fold(0, (sum, m) => sum + m.riskScore);
    return (100 - (totalScore / _members.length)).clamp(0, 100).toInt();
  }

  String? get localIp => _localIp;
  bool get isServerRunning => _isServerRunning;

  QrPayload? generateQrPayload(String adminName) {
    if (_localIp == null) return null;
    return QrPayload(
      familyId: _familyId,
      adminName: adminName,
      ipAddress: _localIp!,
      port: _port,
    );
  }

  void forceFallbackIp() {
    _localIp ??= '192.168.1.100';
    notifyListeners();
  }

  Future<void> startServer() async {
    if (_isServerRunning) return;
    try {
      try {
        final info = NetworkInfo();
        _localIp = await info.getWifiIP();
      } catch (e) {
        // Fall through to manual interface lookup
        _localIp = null;
      }
      
      // Fallback for emulators or restrictive Wi-Fi
      if (_localIp == null) {
        try {
          for (var interface in await NetworkInterface.list()) {
            for (var addr in interface.addresses) {
              if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
                _localIp = addr.address;
                break;
              }
            }
            if (_localIp != null) break;
          }
        } catch (e) {
          _localIp = null;
        }
      }

      // Hard fallback to allow UI to render for demo
      _localIp ??= '192.168.1.100';

      final router = Router();
      
      // Member joins family
      router.post('/join', (Request request) async {
        final payload = await request.readAsString();
        final data = json.decode(payload);
        
        // Add new member
        final newMember = FamilyMember(
          id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: data['name'] ?? 'Unknown Member',
          role: data['role'] ?? 'Member',
          safetyStatus: RiskLevel.safe,
          alertsCount: 0,
          riskScore: 0,
          isShieldActive: true,
          lastSync: DateTime.now(),
        );

        // Avoid duplicates by ID
        final index = _members.indexWhere((m) => m.id == newMember.id);
        if (index == -1) {
          _members.add(newMember);
        } else {
          _members[index] = newMember;
        }

        notifyListeners();
        return Response.ok(json.encode({'status': 'success', 'familyId': _familyId}));
      });

      // Member sends a mock alert
      router.post('/alert', (Request request) async {
        final payload = await request.readAsString();
        final data = json.decode(payload);
        final String memberId = data['memberId'];
        
        final idx = _members.indexWhere((m) => m.id == memberId);
        if (idx != -1) {
          final alert = AlertItem.fromMap(data['alert']);
          final member = _members[idx];
          
          final updatedAlerts = List<AlertItem>.from(member.recentAlerts)..insert(0, alert);
          
          _members[idx] = member.copyWith(
            recentAlerts: updatedAlerts,
            alertsCount: member.alertsCount + 1,
            safetyStatus: alert.severity,
            riskScore: (member.riskScore + 20).clamp(0, 100),
            lastSync: DateTime.now(),
          );
          
          _checkHealthAndNotify();
          notifyListeners();
          return Response.ok(json.encode({'status': 'alert_logged'}));
        }
        return Response.notFound('Member not found');
      });

      // Simple sync status endpoint
      router.get('/sync/<memberId>', (Request request, String memberId) {
        final idx = _members.indexWhere((m) => m.id == memberId);
        if (idx != -1) {
          _members[idx] = _members[idx].copyWith(lastSync: DateTime.now());
          notifyListeners();
          return Response.ok(json.encode({'status': 'synced', 'familyScore': familyCyberScore}));
        }
        return Response.notFound('Member not found');
      });

      // Member sends a help request
      router.post('/help_request', (Request request) async {
        final payload = await request.readAsString();
        final data = json.decode(payload);
        final String memberId = data['memberId'];
        
        final idx = _members.indexWhere((m) => m.id == memberId);
        if (idx != -1) {
          final member = _members[idx];
          
          final alert = AlertItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            category: 'Help Requested',
            severity: RiskLevel.suspicious,
            timestamp: DateTime.now(),
          );
          
          final updatedAlerts = List<AlertItem>.from(member.recentAlerts)..insert(0, alert);
          
          _members[idx] = member.copyWith(
            recentAlerts: updatedAlerts,
            alertsCount: member.alertsCount + 1,
            safetyStatus: RiskLevel.suspicious,
            lastSync: DateTime.now(),
          );
          
          await NotificationService.showNotification(
            id: DateTime.now().millisecondsSinceEpoch % 100000,
            title: '🚨 Family Help Request',
            body: '${member.name} has requested immediate assistance!',
          );
          
          notifyListeners();
          return Response.ok(json.encode({'status': 'help_request_logged'}));
        }
        return Response.notFound('Member not found');
      });

      final handler = Pipeline().addMiddleware(logRequests()).addHandler(router.call);
      
      _server = await io.serve(handler, '0.0.0.0', _port);
      _isServerRunning = true;
      if (kDebugMode) print('Admin LAN Server running on $_localIp:$_port');
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Failed to start LAN server: $e');
    }
  }

  Future<void> stopServer() async {
    await _server?.close(force: true);
    _isServerRunning = false;
    notifyListeners();
  }

  void resetRiskScores() {
    for (int i = 0; i < _members.length; i++) {
      _members[i] = _members[i].copyWith(
        riskScore: 0,
        safetyStatus: RiskLevel.safe,
      );
    }
    _lowScoreNotificationSent = false;
    notifyListeners();
  }

  void _checkHealthAndNotify() {
    if (familyCyberScore < 50 && !_lowScoreNotificationSent) {
      _lowScoreNotificationSent = true;
      
      // Trigger Real Android Notification
      NotificationService.showNotification(
        id: 101,
        title: '🛡️ SECURITY ALERT',
        body: 'Family Network Health is below 50%! Monitor active nodes immediately.',
      );
      
      if (kDebugMode) print('CRITICAL: Network Health below 50%! Sending focus reminder to Admin.');
    } else if (familyCyberScore >= 50) {
      _lowScoreNotificationSent = false;
    }
  }

  bool get shouldShowSafetyReminder => _lowScoreNotificationSent;
  
  void dismissSafetyReminder() {
    _lowScoreNotificationSent = false;
    notifyListeners();
  }
}
