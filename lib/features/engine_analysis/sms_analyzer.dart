import '../sms_detection/providers/sms_stream_provider.dart';
import 'models/analysis_result.dart';

abstract class SmsAnalyzer {
  Future<AnalysisResult> analyze(SmsMessageData message);
}
