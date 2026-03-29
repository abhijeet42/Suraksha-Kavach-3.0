import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

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
    final title = widget.isAdmin ? "Admin Security Portal" : "Member Security Portal";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            FadeInDown(
              child: Text(
                _isSignUp ? 'Create Secured Account' : 'Login to System',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            FadeInDown(
              delay: const Duration(milliseconds: 200),
              child: const Text('Enter your phone number to receive a secure token.', style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 32),
            
            FadeIn(
              delay: const Duration(milliseconds: 500),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18, letterSpacing: 2),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  hintText: '+91 00000 00000',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: ElevatedButton(
                onPressed: () {
                  if (_phoneController.text.isNotEmpty) {
                    context.push('/otp-verify', extra: {
                      'phone': _phoneController.text,
                      'isAdmin': widget.isAdmin,
                      'isSignUp': _isSignUp,
                    });
                  }
                },
                child: const Text('Get Secure OTP'),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Center(
              child: TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: Text(_isSignUp ? 'Already have an account? Login' : 'New here? Create Admin Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
