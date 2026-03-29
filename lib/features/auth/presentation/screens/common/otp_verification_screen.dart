import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../auth/providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final Map<String, dynamic> authData;
  const OtpVerificationScreen({super.key, required this.authData});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onOtpDigitChange(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      // Mock Success for Hackathon
      final isAdmin = widget.authData['isAdmin'] as bool;
      if (isAdmin) {
        context.read<AuthProvider>().loginAsAdmin();
      } else {
        context.read<AuthProvider>().loginAsMember();
      }
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phone = widget.authData['phone'] ?? '+91 00000 00000';

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Access')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            FadeInDown(
              child: const Icon(Icons.security, size: 80, color: Colors.amber),
            ),
            const SizedBox(height: 24),
            FadeInDown(
              delay: const Duration(milliseconds: 300),
              child: const Text('Authentication Token', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            FadeInDown(
              delay: const Duration(milliseconds: 500),
              child: Text(
                'Enter the 6-digit secure code sent to $phone',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 48),
            
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (text) => _onOtpDigitChange(text, index),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.primaryColor, width: 2),
                      ),
                    ),
                  ),
                )),
              ),
            ),
            
            const SizedBox(height: 48),
            
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              child: ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text('Authorize Access'),
              ),
            ),
            
            const SizedBox(height: 16),
            
            FadeIn(
              delay: const Duration(milliseconds: 1500),
              child: TextButton(
                onPressed: () {},
                child: const Text('Resend Token', style: TextStyle(color: Colors.white54)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
