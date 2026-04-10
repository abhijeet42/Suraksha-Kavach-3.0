import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/saved_sms_record.dart';
import '../../../../data/models/threat_report.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../reporting/providers/threat_provider.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SmsDetailScreen extends StatelessWidget {
  final SavedSmsRecord record;

  const SmsDetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy • HH:mm:ss');
    final date = DateTime.fromMillisecondsSinceEpoch(record.timestamp);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.threatAnalysis),
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: record.riskLevel.color.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: BorderSide(color: record.riskLevel.color.withOpacity(0.3), width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                  child: Column(
                    children: [
                      Icon(record.riskLevel.icon, size: 80, color: record.riskLevel.color),
                      const SizedBox(height: 24),
                      Text(
                        record.riskLevel.displayName.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: record.riskLevel.color,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: record.riskLevel.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.riskScore(record.score.toInt().toString()),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: record.riskLevel.color,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              _buildMetaSection(theme, l10n.senderOrigin, record.sender),
              const SizedBox(height: 32),
              _buildMetaSection(theme, l10n.timeReceived, dateFormat.format(date).toUpperCase()),
              const SizedBox(height: 32),

              Text(
                l10n.messageBody,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Text(
                  record.message,
                  style: const TextStyle(fontSize: 16, height: 1.6, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 40),

              Text(
                l10n.aiIntelligenceFlags,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 16),
              ...record.flags.map((flag) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: CircleAvatar(radius: 3, backgroundColor: record.riskLevel.color),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        flag,
                        style: const TextStyle(fontSize: 15, color: Colors.white70, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
              
              const SizedBox(height: 64),
              
              ElevatedButton.icon(
                onPressed: () async {
                  final authProvider = context.read<AuthProvider>();
                  final threatProvider = context.read<ThreatProvider>();
                  final l10n = AppLocalizations.of(context)!;
                  
                  final report = ThreatReport(
                    sender: record.sender,
                    message: record.message,
                    timestamp: DateTime.now(),
                    reportedBy: authProvider.user?.displayName ?? 'Anonymous User',
                    riskLevel: record.riskLevel,
                    location: 'India', // Simulated for threat map feel
                  );

                  try {
                    await threatProvider.reportThreat(report);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.reportSubmitted),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to submit report. Please check your connection.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.report_gmailerrorred_rounded, size: 20),
                label: Text(l10n.reportToDatabase),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                label: Text(l10n.deleteFromHistory, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaSection(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
      ],
    );
  }
}
