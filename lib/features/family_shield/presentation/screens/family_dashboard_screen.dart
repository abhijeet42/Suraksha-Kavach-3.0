import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/family_provider.dart';

class FamilyDashboardScreen extends StatelessWidget {
  const FamilyDashboardScreen({super.key});

  void _showQrOverlay(BuildContext context, String code) {
    showDialog(
      context: context,
      builder: (ctx) => FadeInUp(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Family Entry QR', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ask your family member to scan this code from their User Panel.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: QrImageView(
                  data: code,
                  version: QrVersions.auto,
                  size: 200.0,
                  gapless: false,
                ),
              ),
              const SizedBox(height: 24),
              Text(code, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final familyProvider = context.watch<FamilyProvider>();
    final theme = Theme.of(context);
    const familyCode = 'SK-9921-X'; // Mock code for Hackathon

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Shield'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Stats with Invite Info
            FadeInDown(
              child: Card(
                color: theme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text('YOUR FAMILY INVITE CODE', style: TextStyle(color: Colors.white70, letterSpacing: 1.5, fontSize: 10)),
                      const SizedBox(height: 8),
                      Text(familyCode, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _showQrOverlay(context, familyCode),
                            icon: const Icon(Icons.qr_code, size: 18),
                            label: const Text('Show QR'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white24,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(120, 40),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share, size: 18),
                            label: const Text('Share'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white24,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(120, 40),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: const Text('Protected Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            
            ...familyProvider.members.asMap().entries.map((entry) {
              final member = entry.value;
              return FadeInUp(
                delay: Duration(milliseconds: (300 + (entry.key * 100)).toInt()),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: member.safetyStatus.color.withAlpha(50), width: 1.5),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: member.safetyStatus.color.withAlpha(30),
                      child: Icon(Icons.person, color: member.safetyStatus.color),
                    ),
                    title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Device Profile: ${member.role}'),
                    trailing: Icon(member.safetyStatus.icon, color: member.safetyStatus.color),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
