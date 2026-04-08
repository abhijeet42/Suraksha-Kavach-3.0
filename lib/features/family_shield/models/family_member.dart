import '../../../data/models/risk_level.dart';
import 'alert_item.dart';

class FamilyMember {
  final String id;
  final String name;
  final String role; // "Guardian", "Child", "Elder"
  final RiskLevel safetyStatus; // calculated from alerts
  final int alertsCount;
  final int riskScore; // 0-100
  final bool isShieldActive;
  final DateTime lastSync;
  final List<AlertItem> recentAlerts;

  FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    required this.safetyStatus,
    required this.alertsCount,
    required this.riskScore,
    required this.isShieldActive,
    required this.lastSync,
    this.recentAlerts = const [],
  });

  FamilyMember copyWith({
    String? id,
    String? name,
    String? role,
    RiskLevel? safetyStatus,
    int? alertsCount,
    int? riskScore,
    bool? isShieldActive,
    DateTime? lastSync,
    List<AlertItem>? recentAlerts,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      safetyStatus: safetyStatus ?? this.safetyStatus,
      alertsCount: alertsCount ?? this.alertsCount,
      riskScore: riskScore ?? this.riskScore,
      isShieldActive: isShieldActive ?? this.isShieldActive,
      lastSync: lastSync ?? this.lastSync,
      recentAlerts: recentAlerts ?? this.recentAlerts,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'safetyStatus': safetyStatus.name,
      'alertsCount': alertsCount,
      'riskScore': riskScore,
      'isShieldActive': isShieldActive,
      'lastSync': lastSync.toIso8601String(),
      'recentAlerts': recentAlerts.map((x) => x.toMap()).toList(),
    };
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'Member',
      safetyStatus: RiskLevel.values.firstWhere(
        (e) => e.name == map['safetyStatus'],
        orElse: () => RiskLevel.safe,
      ),
      alertsCount: map['alertsCount']?.toInt() ?? 0,
      riskScore: map['riskScore']?.toInt() ?? 0,
      isShieldActive: map['isShieldActive'] ?? false,
      lastSync: DateTime.tryParse(map['lastSync'] ?? '') ?? DateTime.now(),
      recentAlerts: List<AlertItem>.from(
        (map['recentAlerts'] as List<dynamic>? ?? []).map<AlertItem>(
          (x) => AlertItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
