import '../../../data/models/risk_level.dart';

class AlertItem {
  final String id;
  final String category;
  final RiskLevel severity;
  final DateTime timestamp;

  AlertItem({
    required this.id,
    required this.category,
    required this.severity,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'severity': severity.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AlertItem.fromMap(Map<String, dynamic> map) {
    return AlertItem(
      id: map['id'] ?? '',
      category: map['category'] ?? '',
      severity: RiskLevel.values.firstWhere(
        (e) => e.name == map['severity'],
        orElse: () => RiskLevel.safe,
      ),
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
