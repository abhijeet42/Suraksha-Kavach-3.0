import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../../engine_analysis/sms_analyzer.dart';
import '../../engine_analysis/models/analysis_result.dart';
import '../../engine_analysis/rule_based/rule_based_analyzer.dart';
import '../../history/providers/sms_history_provider.dart';
import '../../../data/models/saved_sms_record.dart';

class SmsMessageData {
  final String sender;
  final String message;
  final int timestamp;

  SmsMessageData({
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  factory SmsMessageData.fromMap(Map<dynamic, dynamic> map) {
    return SmsMessageData(
      sender: map['sender'] ?? 'Unknown',
      message: map['message'] ?? '',
      timestamp: map['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class SmsStreamProvider extends ChangeNotifier {
  static const EventChannel _smsChannel = EventChannel('com.suraksha.kavach/sms_stream');
  
  final SmsAnalyzer _analyzer = RuleBasedAnalyzer();
  SmsHistoryProvider? _historyProvider;
  
  SmsMessageData? _latestMessage;
  AnalysisResult? _latestAnalysis;
  bool _isListening = false;
  bool _isAnalyzing = false;

  SmsMessageData? get latestMessage => _latestMessage;
  AnalysisResult? get latestAnalysis => _latestAnalysis;
  bool get isListening => _isListening;
  bool get isAnalyzing => _isAnalyzing;

  void updateHistoryProvider(SmsHistoryProvider provider) {
    _historyProvider = provider;
  }

  void startListening() {
    if (_isListening) return;
    
    _isListening = true;
    _smsChannel.receiveBroadcastStream().listen((dynamic event) async {
      if (event is Map) {
        _latestMessage = SmsMessageData.fromMap(event);
        _isAnalyzing = true;
        notifyListeners(); 

        _latestAnalysis = await _analyzer.analyze(_latestMessage!);
        _isAnalyzing = false;
        
        // Output to Memory & UI
        notifyListeners();

        // Save to Database (Hive)
        if (_historyProvider != null) {
           final record = SavedSmsRecord(
             sender: _latestMessage!.sender,
             message: _latestMessage!.message,
             timestamp: _latestMessage!.timestamp,
             riskLevel: _latestAnalysis!.level,
             score: _latestAnalysis!.riskScore,
             flags: _latestAnalysis!.flagReasons,
           );
           _historyProvider!.saveSms(record);
        }
      }
    }, onError: (dynamic error) {
      if (kDebugMode) {
        print('SMS Stream Error: $error');
      }
    });
    
    notifyListeners();
  }
}
