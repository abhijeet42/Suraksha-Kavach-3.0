import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('REPORT THREAT')),
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
                'COMMUNITY SHIELD',
                style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Submit suspicious numbers or phishing links to update the global AI security definitions.',
                style: TextStyle(color: Colors.white.withOpacity(0.4), height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: 'SENDER PHONE / ID',
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                  prefixIcon: const Icon(Icons.phone_rounded),
                  fillColor: theme.cardTheme.color,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'SUSPICIOUS MESSAGE CONTENT',
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                  alignLabelWithHint: true,
                  fillColor: theme.cardTheme.color,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report submitted to Community DB!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 20),
                label: const Text('SUBMIT SECURE REPORT', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
