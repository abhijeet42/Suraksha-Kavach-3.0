import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportThreat)),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.withOpacity(0.1),
                ),
                child: const Icon(Icons.security_update_warning_rounded, size: 64, color: Colors.orange),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.communityShield,
                style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.communityShieldDesc,
                style: TextStyle(color: Colors.white.withOpacity(0.4), height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: l10n.senderPhoneId,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                  prefixIcon: const Icon(Icons.phone_rounded),
                  fillColor: theme.cardTheme.color,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.suspiciousMessageContent,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                  alignLabelWithHint: true,
                  fillColor: theme.cardTheme.color,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.reportSubmitted),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 20),
                label: Text(l10n.submitSecureReport, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
