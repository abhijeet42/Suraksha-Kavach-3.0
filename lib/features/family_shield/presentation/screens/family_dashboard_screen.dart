import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha_kavach/features/family_shield/providers/family_provider.dart';

class FamilyDashboardScreen extends StatelessWidget {
  const FamilyDashboardScreen({super.key});

  void _showQrOverlay(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (ctx) => FadeIn(
        duration: const Duration(milliseconds: 400),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
          title: Text(
            'FAMILY ENTRY QR',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scan this code from the User Panel to join the family group.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5)),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: QrImageView(
                  data: code,
                  version: QrVersions.auto,
                  size: 200.0,
                  gapless: false,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                code,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('DISMISS', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final familyProvider = context.watch<FamilyProvider>();
    final theme = Theme.of(context);
    const familyCode = 'SK-9921-X';

    return Scaffold(
      appBar: AppBar(
        title: const Text('FAMILY SHIELD'),
      ),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: theme.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        'FAMILY INVITE CODE',
                        style: GoogleFonts.inter(
                          color: Colors.black.withOpacity(0.4),
                          letterSpacing: 2,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        familyCode,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _showQrOverlay(context, familyCode),
                              icon: const Icon(Icons.qr_code_rounded, size: 20),
                              label: const Text('SHOW QR'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.1),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.copy_rounded, size: 20),
                              label: const Text('COPY CODE'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.1),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              Text(
                'PROTECTED MEMBERS',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              const SizedBox(height: 16),
              
              ...familyProvider.members.map((member) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: member.safetyStatus.color.withOpacity(0.15), width: 1.5),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: member.safetyStatus.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person_rounded, color: member.safetyStatus.color, size: 24),
                      ),
                      title: Text(
                        member.name,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                      ),
                      subtitle: Text(
                        'Active Shield: ${member.role}',
                        style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
                      ),
                      trailing: Icon(member.safetyStatus.icon, color: member.safetyStatus.color, size: 22),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
