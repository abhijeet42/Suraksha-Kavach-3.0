import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneAuthScreen extends StatefulWidget {
  final bool isAdmin;
  const PhoneAuthScreen({super.key, required this.isAdmin});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  bool _isSignUp = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.isAdmin ? "ADMIN PORTAL" : "MEMBER PORTAL";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                _isSignUp ? 'SECURE ACCOUNT' : 'SYSTEM LOGIN',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your phone number to receive a secure access token.',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
              ),
              const SizedBox(height: 48),
              
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: 'PHONE NUMBER',
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                  prefixIcon: const Icon(Icons.phone_iphone_rounded),
                  hintText: '+91 00000 00000',
                  fillColor: theme.cardTheme.color,
                ),
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () {
                  if (_phoneController.text.isNotEmpty) {
                    context.push('/otp-verify', extra: {
                      'phone': _phoneController.text,
                      'isAdmin': widget.isAdmin,
                      'isSignUp': _isSignUp,
                    });
                  }
                },
                child: const Text('GET SECURE OTP'),
              ),
              
              const SizedBox(height: 24),
              
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(
                    _isSignUp ? 'ALREADY REGISTERED? LOGIN' : 'NEW ADMIN? CREATE ACCOUNT',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
