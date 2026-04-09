import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/risk_level.dart';
import '../models/qr_payload.dart';
import '../models/alert_item.dart';

class FamilyMemberProvider extends ChangeNotifier {
  QrPayload? _connectedFamily;
  String _memberId = 'MEM-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  Timer? _syncTimer;
  int _familyScore = 100;
  bool _isConnected = false;
  QrPayload? _pendingPayload;

  QrPayload? get connectedFamily => _connectedFamily;
  bool get isConnected => _isConnected;
  int get familyScore => _familyScore;

  void setPendingPayload(QrPayload payload) {
    _pendingPayload = payload;
    notifyListeners();
  }

  Future<bool> joinFamily(String memberName) async {
    if (_pendingPayload == null) return false;
    final payload = _pendingPayload!;
    final url = Uri.parse('http://${payload.ipAddress}:${payload.port}/join');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': _memberId,
          'name': memberName,
          'role': 'Member',
        }),
      );

      if (response.statusCode == 200) {
        _connectedFamily = payload;
        _isConnected = true;
        _pendingPayload = null;
        _startSyncTimer();
        notifyListeners();
        return true;
      }
    } catch (e) {
      if (kDebugMode) print('Failed to join family: $e');
    }
    return false;
  }

  void _startSyncTimer() {
    _syncTimer?.cancel();
    // Poll the admin server every 5 seconds to show we are online
    _syncTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_connectedFamily == null) return;
      final url = Uri.parse('http://${_connectedFamily!.ipAddress}:${_connectedFamily!.port}/sync/$_memberId');
      try {
        final response = await http.get(url).timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          _familyScore = data['familyScore'] ?? 100;
          notifyListeners();
        }
      } catch (e) {
        if (kDebugMode) print('Sync heartbeat failed (Admin might be offline)');
      }
    });
  }

  // Triggered by local SMS Detection Engine
  Future<void> sendAlertToAdmin(AlertItem alert) async {
    if (_connectedFamily == null) return;
    
    final url = Uri.parse('http://${_connectedFamily!.ipAddress}:${_connectedFamily!.port}/alert');
    try {
      await http.post(
        url,
        body: json.encode({
          'memberId': _memberId,
          'alert': alert.toMap(),
        }),
      );
    } catch (e) {
      if (kDebugMode) print('Failed to send alert to admin: $e');
    }
  }

  // For Demo Purposes
  Future<void> sendMockHackathonAlert() async {
    final alert = AlertItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: 'Phishing SMS Blocked',
      severity: RiskLevel.scam,
      timestamp: DateTime.now(),
    );
    await sendAlertToAdmin(alert);
  }

  void leaveFamily() {
    _syncTimer?.cancel();
    _connectedFamily = null;
    _isConnected = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}
