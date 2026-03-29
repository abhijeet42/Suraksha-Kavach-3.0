import 'package:flutter/material.dart';
import '../../../../data/models/saved_sms_record.dart';
import 'package:intl/intl.dart';

class SmsDetailScreen extends StatelessWidget {
  final SavedSmsRecord record;

  const SmsDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy - HH:mm:ss');
    final date = DateTime.fromMillisecondsSinceEpoch(record.timestamp);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Threat Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Risk Header
            Card(
              color: record.riskLevel.color.withAlpha(25),
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: record.riskLevel.color, width: 2),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(record.riskLevel.icon, size: 64, color: record.riskLevel.color),
                    const SizedBox(height: 12),
                    Text(
                      record.riskLevel.displayName,
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: record.riskLevel.color,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${record.score.toInt()}% Threat Score', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Meta Info
            Text('Sender Origin', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 4),
            Text(record.sender, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            Text('Time Received', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 4),
            Text(dateFormat.format(date), style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),

            // Message Body
            const Text('Message Body', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(record.message, style: const TextStyle(fontSize: 16, height: 1.5)),
            ),
            const SizedBox(height: 24),

            // Flag Reasons
            const Text('AI Threat Intelligence Flags', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...record.flags.map((flag) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.flag, color: record.riskLevel.color, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(flag, style: const TextStyle(fontSize: 15))),
                ],
              ),
            )),
            
            const SizedBox(height: 40),
            
            // Actions
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.report, color: Colors.white),
              label: const Text('Report to Community Database', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // Future Implementation -> call Provider delete
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Delete Log', style: TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}
