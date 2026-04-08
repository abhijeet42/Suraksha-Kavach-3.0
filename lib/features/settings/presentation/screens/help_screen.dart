import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HELP & SUPPORT')),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'SURAKSHA KAVACH FAQ',
              style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
            ),
            const SizedBox(height: 24),
            _buildHelpItem(
              'How does AI detection work?',
              'Our engine analyzes message syntax, sender reputation, and link metadata locally. No data leaves your device unless you manually report it.',
            ),
            _buildHelpItem(
              'Is it completely free?',
              'Yes, the core protection features for individuals and families are free. Community reporting helps keep the database updated for everyone.',
            ),
            _buildHelpItem(
              'How to add family members?',
              'Admins can generate an invite code in the Family tab. Members can join by scanning the QR code or entering the ID.',
            ),
            const Divider(height: 64, color: Colors.white10),
            Text(
              'CONTACT SECURITY TEAM',
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
