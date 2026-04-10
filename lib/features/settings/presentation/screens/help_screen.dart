import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpSupportHeader)),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              l10n.faqHeader,
              style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
            ),
            const SizedBox(height: 24),
            _buildHelpItem(
              l10n.q1,
              l10n.a1,
            ),
            _buildHelpItem(
              l10n.q2,
              l10n.a2,
            ),
            _buildHelpItem(
              l10n.q3,
              l10n.a3,
            ),
            const Divider(height: 64, color: Colors.white10),
            Text(
              l10n.contactSecurityTeam,
              style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1, color: Colors.white38),
            ),
            const SizedBox(height: 16),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.email_rounded, color: Colors.amber),
              title: Text('support@surakshakavach.app', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone_in_talk_rounded, color: Colors.amber),
              title: Text('+91 1800-SAFE-EYE', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(String q, String a) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.amber)),
          const SizedBox(height: 10),
          Text(
            a,
            style: TextStyle(color: Colors.white.withOpacity(0.5), height: 1.6, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
