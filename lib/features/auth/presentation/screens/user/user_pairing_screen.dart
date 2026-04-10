import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/features/family_shield/providers/family_member_provider.dart';
import 'package:suraksha_kavach/features/family_shield/models/qr_payload.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

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
      QrPayload payload;
      
      // Hardcoded bypass for testing purposes
      if (rawValue.trim() == '123') {
        payload = QrPayload(
          familyId: 'FAM-TEST-123',
          adminName: 'Test Admin',
          ipAddress: '127.0.0.1',
          port: 8080,
        );
      } else {
        payload = QrPayload.fromJson(rawValue);
      }
      
      context.read<FamilyMemberProvider>().setPendingPayload(payload);
      
      if (context.mounted) {
        context.push('/user-auth', extra: {'isMock': true});
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.invalidQrCode), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isScanning) {
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.scanAdminQr),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.familyPairing)),
      body: SingleChildScrollView(
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
                l10n.pairDevice,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.joinFamilyDesc,
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
                  label: Text(l10n.scanQrCode),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                ),
              
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.05))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(l10n.orEnterManually, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white.withOpacity(0.2), letterSpacing: 1)),
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
                      labelText: l10n.jsonPayloadLabel,
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
                    child: Text(l10n.joinFamilyGroup),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
