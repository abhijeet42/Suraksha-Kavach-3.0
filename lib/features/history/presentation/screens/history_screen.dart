import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/sms_history_provider.dart';
import '../../../../data/models/risk_level.dart';
import 'sms_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<SmsHistoryProvider>();
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('THREAT LOGS'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: TextField(
              onChanged: (val) => context.read<SmsHistoryProvider>().setSearchQuery(val),
              decoration: InputDecoration(
                hintText: 'Search sender or message keywords...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                fillColor: theme.cardTheme.color,
              ),
            ),
          ),
        ),
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _buildFilterChip(context, 'ALL', null, null),
                  const SizedBox(width: 10),
                  _buildFilterChip(context, 'SCAM', RiskLevel.scam, Colors.redAccent),
                  const SizedBox(width: 10),
                  _buildFilterChip(context, 'SUSPICIOUS', RiskLevel.suspicious, Colors.orangeAccent),
                  const SizedBox(width: 10),
                  _buildFilterChip(context, 'SAFE', RiskLevel.safe, Colors.greenAccent),
                ],
              ),
            ),
            Expanded(
              child: historyProvider.isLoading
                  ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                  : historyProvider.records.isEmpty
                      ? _buildEmptyState(theme)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: historyProvider.records.length,
                          itemBuilder: (context, idx) {
                            final record = historyProvider.records[idx];
                            final date = DateTime.fromMillisecondsSinceEpoch(record.timestamp);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Card(
                                color: record.riskLevel.color.withOpacity(0.04),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: record.riskLevel.color.withOpacity(0.12),
                                    width: 1.5,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: record.riskLevel.color.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(record.riskLevel.icon, color: record.riskLevel.color, size: 24),
                                  ),
                                  title: Text(
                                    record.sender,
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        record.message,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        dateFormat.format(date).toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                          color: Colors.white24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withOpacity(0.1)),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SmsDetailScreen(record: record),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 64, color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 16),
          Text(
            'No matching threat logs.',
            style: TextStyle(color: Colors.white.withOpacity(0.2), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, RiskLevel? level, Color? dotColor) {
    final activeFilter = context.watch<SmsHistoryProvider>().activeFilter;
    final isSelected = activeFilter == level;
    final theme = Theme.of(context);

    return FilterChip(
      showCheckmark: false,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
          color: isSelected ? Colors.black : Colors.white54,
        ),
      ),
      selected: isSelected,
      selectedColor: theme.primaryColor,
      backgroundColor: theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? theme.primaryColor : Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      onSelected: (bool selected) {
        context.read<SmsHistoryProvider>().setFilter(selected ? level : null);
      },
    );
  }
}
