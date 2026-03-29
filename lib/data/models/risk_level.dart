import 'package:flutter/material.dart';

enum RiskLevel {
  safe,
  suspicious,
  scam;

  Color get color {
    switch (this) {
      case RiskLevel.safe:
        return Colors.green;
      case RiskLevel.suspicious:
        return Colors.orangeAccent.shade700;
      case RiskLevel.scam:
        return Colors.redAccent.shade700;
    }
  }

  IconData get icon {
    switch (this) {
      case RiskLevel.safe:
        return Icons.check_circle_outline;
      case RiskLevel.suspicious:
        return Icons.warning_amber_rounded;
      case RiskLevel.scam:
        return Icons.dangerous_outlined;
    }
  }

  String get displayName {
    switch (this) {
      case RiskLevel.safe:
        return 'Safe';
      case RiskLevel.suspicious:
        return 'Suspicious';
      case RiskLevel.scam:
        return 'Scam Detected!';
    }
  }
}
