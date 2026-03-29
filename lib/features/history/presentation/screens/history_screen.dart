import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sms_history_provider.dart';
import '../../../../data/models/risk_level.dart';
import 'sms_detail_screen.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<SmsHistoryProvider>();

    final dateFormat = DateFormat('MMM dd, yyyy - HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Threat History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search sender or message...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (val) => context.read<SmsHistoryProvider>().setSearchQuery(val),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip(context, 'All', null, null),
                const SizedBox(width: 8),
                _buildFilterChip(context, 'Scam', RiskLevel.scam, Colors.red),
                const SizedBox(width: 8),
                _buildFilterChip(context, 'Suspicious', RiskLevel.suspicious, Colors.orange),
                const SizedBox(width: 8),
                _buildFilterChip(context, 'Safe', RiskLevel.safe, Colors.green),
              ],
            ),
          ),
          const Divider(),
          // List View
          Expanded(
            child: historyProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : historyProvider.records.isEmpty
                    ? const Center(child: Text('No messages found based on filters.'))
                    : ListView.builder(
                        itemCount: historyProvider.records.length,
                        itemBuilder: (context, idx) {
                          final record = historyProvider.records[idx];
                          final date = DateTime.fromMillisecondsSinceEpoch(record.timestamp);

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: record.riskLevel.color.withAlpha(20),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: record.riskLevel.color.withAlpha(100)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Icon(record.riskLevel.icon, color: record.riskLevel.color, size: 36),
                              title: Text(record.sender, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record.message,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateFormat.format(date),
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SmsDetailScreen(record: record),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, RiskLevel? level, Color? dotColor) {
    final activeFilter = context.watch<SmsHistoryProvider>().activeFilter;
    final isSelected = activeFilter == level;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
            ),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        context.read<SmsHistoryProvider>().setFilter(selected ? level : null);
      },
    );
  }
}
