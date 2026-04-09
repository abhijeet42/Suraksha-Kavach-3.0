import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';

class EmailAuthScreen extends StatefulWidget {
  final bool isAdmin;
  const EmailAuthScreen({super.key, required this.isAdmin});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _emailController = TextEditingController();

  void _onNext() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    await context.read<AuthProvider>().sendMockOtp(_emailController.text, widget.isAdmin);
    
    if (mounted) {
      context.push('/otp-verify', extra: {
        'phone': _emailController.text, // repurposed for email
        'isAdmin': widget.isAdmin,
        'isMock': true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMAIL AUTHENTICATION')),
      body: FadeIn(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.alternate_email_rounded, size: 80, color: Colors.purpleAccent),
              const SizedBox(height: 32),
              Text(
                'ENTER EMAIL',
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'We will send a secure verification code to your inbox.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'EMAIL ADDRESS',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent),
                child: const Text('GET VERIFICATION CODE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
