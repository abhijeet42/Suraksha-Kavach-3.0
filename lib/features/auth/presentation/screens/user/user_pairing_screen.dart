import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/features/family_shield/providers/family_member_provider.dart';
import 'package:suraksha_kavach/features/family_shield/models/qr_payload.dart';

class UserPairingScreen extends StatefulWidget {
  const UserPairingScreen({super.key});

  @override
  State<UserPairingScreen> createState() => _UserPairingScreenState();
}

class _UserPairingScreenState extends State<UserPairingScreen> {
  final _codeController = TextEditingController();
  bool _isScanning = false;
  bool _isProcessing = false;

  void _showScanner() {
    setState(() => _isScanning = true);
  }

  void _onScanSuccess(BarcodeCapture capture) async {
    if (_isProcessing) return;
    final String? rawValue = capture.barcodes.first.rawValue;
    if (rawValue != null) {
      setState(() {
        _isProcessing = true;
        _isScanning = false;
      });
      await _processPayload(rawValue);
    }
  }

  Future<void> _processPayload(String rawValue) async {
    try {
      final payload = QrPayload.fromJson(rawValue);
      final success = await context.read<FamilyMemberProvider>().joinFamily(payload, 'Child Device');
      
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Joined Family: ${payload.adminName}'), backgroundColor: Colors.green),
          );
          // Auto login as member for demo
          // We will trigger a fake login sequence and go to dashboard
          context.go('/dashboard');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to join family. Ensure on same WiFi.'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR Code format'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isScanning) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SCAN ADMIN QR'),
          leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => setState(() {
            _isScanning = false;
            _isProcessing = false;
          })),
        ),
        body: MobileScanner(
          onDetect: _onScanSuccess,
        ),
      );
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('FAMILY PAIRING')),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(0.1),
                ),
                child: const Icon(Icons.qr_code_scanner_rounded, size: 80, color: Colors.blueAccent),
              ),
              const SizedBox(height: 32),
              Text(
                'PAIR DEVICE',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Join a family group to enable shared threat intelligence and protected scanning.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.4), height: 1.5),
              ),
              const SizedBox(height: 56),
              
              if (_isProcessing)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _showScanner,
                  icon: const Icon(Icons.camera_alt_rounded, size: 20),
                  label: const Text('SCAN ADMIN QR CODE'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                ),
              
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.05))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR ENTER MANUALLY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white.withOpacity(0.2), letterSpacing: 1)),
                  ),
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.05))),
                ],
              ),
              const SizedBox(height: 48),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   TextField(
                    controller: _codeController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, letterSpacing: 4, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: 'JSON PAYLOAD (HACKATHON OVERRIDE)',
                      labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                      hintText: 'Paste JSON here manually if scanner fails',
                      fillColor: theme.cardTheme.color,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : () {
                      if (_codeController.text.isNotEmpty) {
                        setState(() => _isProcessing = true);
                        _processPayload(_codeController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('JOIN FAMILY GROUP'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
