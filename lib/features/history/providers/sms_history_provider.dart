import 'package:flutter/foundation.dart';
import '../../../data/models/saved_sms_record.dart';
import '../../../data/models/risk_level.dart';
import '../../../core/database/hive_service.dart';

class SmsHistoryProvider extends ChangeNotifier {
  List<SavedSmsRecord> _allRecords = [];
  List<SavedSmsRecord> _filteredRecords = [];
  
  RiskLevel? _activeFilter;
  String _searchQuery = '';
  bool _isLoading = false;

  List<SavedSmsRecord> get records => _filteredRecords;
  bool get isLoading => _isLoading;
  RiskLevel? get activeFilter => _activeFilter;

  // Stats
  int get totalScams => _allRecords.where((r) => r.riskLevel == RiskLevel.scam).length;
  int get totalSafe => _allRecords.where((r) => r.riskLevel == RiskLevel.safe).length;
  int get totalSuspicious => _allRecords.where((r) => r.riskLevel == RiskLevel.suspicious).length;

  SmsHistoryProvider() {
    loadHistory();
  }

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    final historyData = HiveService.getSmsHistory();
    _allRecords = historyData.map((e) => SavedSmsRecord.fromMap(Map<String, dynamic>.from(e))).toList();
    _applyFilters();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveSms(SavedSmsRecord record) async {
    await HiveService.saveSms(record.toMap());
    _allRecords.insert(0, record);
    _applyFilters();
    notifyListeners();
  }

  Future<void> deleteRecord(int index) async {
    await HiveService.deleteSms(index);
    _allRecords.removeAt(index);
    _applyFilters();
    notifyListeners();
  }

  void setFilter(RiskLevel? level) {
    _activeFilter = level;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredRecords = _allRecords.where((r) {
      final matchesFilter = _activeFilter == null || r.riskLevel == _activeFilter;
      final matchesSearch = r.sender.toLowerCase().contains(_searchQuery) ||
                            r.message.toLowerCase().contains(_searchQuery);
      return matchesFilter && matchesSearch;
    }).toList();
  }
}
