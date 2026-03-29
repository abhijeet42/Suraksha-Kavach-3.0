import '../../../data/models/risk_level.dart';

class FamilyMember {
  final String id;
  final String name;
  final String role; // "Mom", "Child"
  final RiskLevel safetyStatus;
  final int alertsCount;

  FamilyMember({
    required this.id,
    required this.name,
    required this.role,
    required this.safetyStatus,
    required this.alertsCount,
  });
}
