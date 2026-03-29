import '../../../data/models/risk_level.dart';

class AnalysisResult {
  final RiskLevel level;
  final double riskScore;
  final List<String> flagReasons;

  AnalysisResult({
    required this.level,
    required this.riskScore,
    required this.flagReasons,
  });

  factory AnalysisResult.safe() {
    return AnalysisResult(
      level: RiskLevel.safe,
      riskScore: 0.0,
      flagReasons: ['No suspicious patterns detected.'],
    );
  }
}
