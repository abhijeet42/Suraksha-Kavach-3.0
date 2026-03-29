import 'dart:convert';
import 'risk_level.dart';

class SavedSmsRecord {
  final int? id;
  final String sender;
  final String message;
  final int timestamp;
  final RiskLevel riskLevel;
  final double score;
  final List<String> flags;

  SavedSmsRecord({
    this.id,
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.riskLevel,
    required this.score,
    required this.flags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'message': message,
      'timestamp': timestamp,
      'riskLevel': riskLevel.name,
      'score': score,
      'flags': jsonEncode(flags),
    };
  }

  factory SavedSmsRecord.fromMap(Map<String, dynamic> map) {
    return SavedSmsRecord(
      id: map['id'],
      sender: map['sender'],
      message: map['message'],
      timestamp: map['timestamp'],
      riskLevel: RiskLevel.values.firstWhere((e) => e.name == map['riskLevel']),
      score: map['score']?.toDouble() ?? 0.0,
      flags: List<String>.from(jsonDecode(map['flags'])),
    );
  }
}
