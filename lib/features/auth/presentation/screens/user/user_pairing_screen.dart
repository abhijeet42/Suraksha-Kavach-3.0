import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPairingScreen extends StatefulWidget {
  const UserPairingScreen({super.key});

  @override
  State<UserPairingScreen> createState() => _UserPairingScreenState();
}

class _UserPairingScreenState extends State<UserPairingScreen> {
  final _codeController = TextEditingController();
  bool _isScanning = false;

  void _onCodeValid() {
    context.push('/user-auth');
  }

  void _showScanner() {
    setState(() => _isScanning = true);
  }

  void _onScanSuccess(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty) {
      setState(() => _isScanning = false);
      _onCodeValid();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isScanning) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SCAN ADMIN QR'),
          leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => setState(() => _isScanning = false)),
        ),
        body: MobileScanner(
          onDetect: _onScanSuccess,
        ),
      );
    }

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
                      labelText: 'FAMILY INVITE CODE',
                      labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                      hintText: 'ABCD-1234',
                      fillColor: theme.cardTheme.color,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_codeController.text.isNotEmpty) {
                        _onCodeValid();
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
