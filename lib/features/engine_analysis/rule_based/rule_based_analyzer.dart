import '../sms_analyzer.dart';
import '../models/analysis_result.dart';
import '../../sms_detection/providers/sms_stream_provider.dart';
import '../../../data/models/risk_level.dart';

class RuleBasedAnalyzer implements SmsAnalyzer {
  final List<String> scamKeywords = [
    'lottery', 'won', 'cash prize', 'free gift', 'urgent', 'block', 
    'kyc', 'action required', 'account suspended', 'click here'
  ];

  @override
  Future<AnalysisResult> analyze(SmsMessageData message) async {
    // Artificial slight delay to simulate processing
    await Future.delayed(const Duration(milliseconds: 300));
    
    double score = 0;
    List<String> reasons = [];
    String text = message.message.toLowerCase();

    // 1. Link Detection (Simple Regex)
    final urlRegExp = RegExp(r'(https?:\/\/[^\s]+)|(www\.[^\s]+)');
    if (urlRegExp.hasMatch(text)) {
      score += 40;
      reasons.add('Contains an embedded hyperlink.');
    }

    // 2. Keyword matching
    for (String keyword in scamKeywords) {
      if (text.contains(keyword)) {
        score += 20;
        reasons.add('Urgent/Suspicious keyword detected: "$keyword".');
      }
    }

    // 3. Sender Validation
    if (message.sender.startsWith('+') || message.sender.length >= 10) {
      // 10-digit numbers sending links/urgency is a huge red flag
      score += 15;
      reasons.add('Standard phone number acting like an institution.');
    } else {
      reasons.add('Sender is a shortcode (typically safer).');
    }

    // Bound score
    if (score > 100) score = 100;

    // Determine RiskLevel based on score
    RiskLevel level;
    if (score <= 30) {
      level = RiskLevel.safe;
      if (reasons.isEmpty || reasons.length == 1 && reasons[0].contains('shortcode')) {
        reasons.clear();
        reasons.add('No threats detected.');
      }
    } else if (score <= 70) {
      level = RiskLevel.suspicious;
    } else {
      level = RiskLevel.scam;
    }

    return AnalysisResult(
      level: level,
      riskScore: score,
      flagReasons: reasons,
    );
  }
}
