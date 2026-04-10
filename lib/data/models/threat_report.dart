import 'package:cloud_firestore/cloud_firestore.dart';
import 'risk_level.dart';

class ThreatReport {
  final String? id;
  final String sender;
  final String message;
  final DateTime timestamp;
  final String reportedBy;
  final RiskLevel riskLevel;
  final String location; // Simulated location for "Threat Map" feel

  ThreatReport({
    this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.reportedBy,
    required this.riskLevel,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'reportedBy': reportedBy,
      'riskLevel': riskLevel.name,
      'location': location,
    };
  }

  factory ThreatReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ThreatReport(
      id: doc.id,
      sender: data['sender'] ?? 'Unknown',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      reportedBy: data['reportedBy'] ?? 'Anonymous',
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.name == data['riskLevel'],
        orElse: () => RiskLevel.scam,
      ),
      location: data['location'] ?? 'Global',
    );
  }
}
