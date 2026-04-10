import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../core/services/firestore_service.dart';
import '../../../data/models/threat_report.dart';

class ThreatProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<ThreatReport> _threats = [];
  StreamSubscription<List<ThreatReport>>? _subscription;
  bool _isLoading = true;

  List<ThreatReport> get threats => _threats;
  bool get isLoading => _isLoading;

  ThreatProvider() {
    _startListening();
  }

  void _startListening() {
    _subscription = _firestoreService.getThreatFeedStream().listen(
      (data) {
        _threats = data;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        print('Error in ThreatProvider stream: $error');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> reportThreat(ThreatReport report) async {
    await _firestoreService.submitReport(report);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
