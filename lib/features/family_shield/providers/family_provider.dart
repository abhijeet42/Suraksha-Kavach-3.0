import 'package:flutter/foundation.dart';
import '../models/family_member.dart';
import '../../../data/models/risk_level.dart';

class FamilyProvider extends ChangeNotifier {
  // Mock data for Hackathon UI evaluation
  final List<FamilyMember> _members = [
    FamilyMember(
      id: '1',
      name: 'Sunita Sharma',
      role: 'Mom',
      safetyStatus: RiskLevel.scam,
      alertsCount: 2,
    ),
    FamilyMember(
      id: '2',
      name: 'Rohan Sharma',
      role: 'Brother',
      safetyStatus: RiskLevel.safe,
      alertsCount: 0,
    ),
  ];

  List<FamilyMember> get members => _members;

  int get totalMembers => _members.length;
  int get membersAtRisk => _members.where((m) => m.safetyStatus != RiskLevel.safe).length;
}
