import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
    if (_isScanning) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan Admin QR'),
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _isScanning = false)),
        ),
        body: MobileScanner(
          onDetect: _onScanSuccess,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Family Shield Pairing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            FadeInDown(
              child: const Icon(Icons.qr_code_scanner, size: 100, color: Colors.blueAccent),
            ),
            const SizedBox(height: 24),
            FadeInDown(
              delay: const Duration(milliseconds: 300),
              child: const Text('Pair Your Device', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            FadeInDown(
              delay: const Duration(milliseconds: 500),
              child: const Text(
                'Join a family group to enable shared threat intelligence and admin protection.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 48),
            
            FadeInLeft(
              delay: const Duration(milliseconds: 700),
              child: ElevatedButton.icon(
                onPressed: _showScanner,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Scan Admin QR Code'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
            ),
            
            const SizedBox(height: 32),
            
            FadeIn(
              delay: const Duration(milliseconds: 900),
              child: const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('OR')),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            FadeInRight(
              delay: const Duration(milliseconds: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _codeController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, letterSpacing: 4, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: 'Family Invite Code',
                      hintText: 'ABCD-1234',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_codeController.text.isNotEmpty) {
                        _onCodeValid();
                      }
                    },
                    child: const Text('Join Family Group'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
