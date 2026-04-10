import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/threat_report.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionPath = 'community_reports';

  // Submit a new threat report
  Future<void> submitReport(ThreatReport report) async {
    try {
      await _db.collection(collectionPath).add(report.toMap());
    } catch (e) {
      print('Error submitting report: $e');
      rethrow;
    }
  }

  // Get real-time stream of reports (sorted by newest first)
  Stream<List<ThreatReport>> getThreatFeedStream() {
    return _db
        .collection(collectionPath)
        .orderBy('timestamp', descending: true)
        .limit(50) // Keep the feed to 50 most recent
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ThreatReport.fromFirestore(doc)).toList();
    });
  }
}
