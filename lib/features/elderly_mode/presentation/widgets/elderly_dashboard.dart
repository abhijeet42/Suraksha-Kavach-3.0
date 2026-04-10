import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:suraksha_kavach/features/sms_detection/providers/sms_stream_provider.dart';
import 'package:suraksha_kavach/features/history/providers/sms_history_provider.dart';
import 'package:suraksha_kavach/features/family_shield/providers/family_member_provider.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';
import 'package:suraksha_kavach/core/services/voice_service.dart';

/// A simplified, senior-friendly dashboard.
/// 
/// STABILITY RULES followed here:
///   - StatelessWidget only (no tickers, no animations)
///   - No FadeIn / animate_do widgets
///   - No conditional widget counts in lists
///   - All async calls guarded by mounted checks at callsites
class ElderlyDashboard extends StatelessWidget {
  const ElderlyDashboard({super.key});

  void _askFamilyForHelp(BuildContext context) {
    final memberProvider = context.read<FamilyMemberProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (memberProvider.isConnected) {
      memberProvider.sendHelpRequestToAdmin();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.elderlyHelpSent,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.pink.shade600,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            l10n.elderlyFamilyNotConnected,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Text(
            l10n.elderlyNotConnectedDesc,
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.elderlyCancel, style: const TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                launchUrl(Uri.parse('tel:1930'));
              },
              child: Text(l10n.elderlyCallHelpline, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<SmsHistoryProvider>();
    final smsProvider = context.watch<SmsStreamProvider>();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final int scamCount = historyProvider.totalScams;
    final bool isSafe = scamCount == 0;
    final Color statusColor = isSafe ? Colors.green.shade400 : Colors.orange.shade400;
    final IconData statusIcon = isSafe ? Icons.verified_user_rounded : Icons.warning_amber_rounded;
    final String statusTitle = isSafe ? l10n.elderlyPhoneSafe : l10n.elderlyBeCareful;
    final String statusBody = isSafe
        ? l10n.elderlySafeBody
        : l10n.elderlyDangerBody(scamCount.toString());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Greeting ──────────────────────────────────────────────────────
          Text(
            l10n.elderlyHello,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.elderlyDailySummaryText,
            style: const TextStyle(fontSize: 18, color: Colors.white60),
          ),
          const SizedBox(height: 28),

          // ── Daily Safety Summary Card ──────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: statusColor.withOpacity(0.4), width: 2),
            ),
            child: Column(
              children: [
                Icon(statusIcon, color: statusColor, size: 72),
                const SizedBox(height: 16),
                Text(
                  statusTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  statusBody,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17, color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Ask Family for Help ──────────────────────────────────────────
          _ElderlyButton(
            label: l10n.elderlyAskFamilyForHelp,
            icon: Icons.family_restroom_rounded,
            color: Colors.pink.shade400,
            onTap: () => _askFamilyForHelp(context),
          ),
          const SizedBox(height: 16),

          // ── Call Helpline ────────────────────────────────────────────────
          _ElderlyButton(
            label: l10n.elderlyCallCyberHelpline,
            icon: Icons.phone_in_talk_rounded,
            color: Colors.teal.shade400,
            onTap: () => launchUrl(Uri.parse('tel:1930')),
          ),
          const SizedBox(height: 28),

          // ── Recent Message Check ─────────────────────────────────────────
          Text(
            l10n.elderlyLatestSafetyCheck,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 12),

          if (smsProvider.latestMessage != null && smsProvider.latestAnalysis != null)
            _LatestMessageCard(provider: smsProvider)
          else
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(10), // used withAlpha to fix deprecation warning
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  l10n.elderlyNoMessages,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.white38, height: 1.6),
                ),
              ),
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ── Private helper widgets ─────────────────────────────────────────────────────

class _ElderlyButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ElderlyButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4), width: 2),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: color.withOpacity(0.6), size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _LatestMessageCard extends StatelessWidget {
  final SmsStreamProvider provider;
  const _LatestMessageCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final analysis = provider.latestAnalysis!;
    final msg = provider.latestMessage!;
    final bool isDangerous = analysis.riskScore > 50;
    final Color color = isDangerous ? Colors.red.shade400 : Colors.green.shade400;
    final IconData icon = isDangerous ? Icons.dangerous_rounded : Icons.verified_user_rounded;
    final String verdict = isDangerous ? l10n.elderlyDangerousVerdict : l10n.elderlySafeVerdict;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  verdict,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color, height: 1.3),
                ),
              ),
              IconButton(
                onPressed: () {
                  VoiceService.speak(verdict);
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Row(
                         children: [
                           const Icon(Icons.record_voice_over, color: Colors.white, size: 28),
                           const SizedBox(width: 12),
                           Expanded(
                             child: Text(
                               l10n.elderlyReadingAloud(verdict), 
                               style: const TextStyle(fontSize: 18, color: Colors.white)
                             )
                           ),
                         ]
                       ),
                       behavior: SnackBarBehavior.floating,
                     )
                   );
                },
                icon: const Icon(Icons.volume_up_rounded, size: 36, color: Colors.white70),
                tooltip: 'Read Aloud',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.elderlyFromSender(msg.sender),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            msg.message,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, color: Colors.white70, height: 1.4),
          ),
        ],
      ),
    );
  }
}
