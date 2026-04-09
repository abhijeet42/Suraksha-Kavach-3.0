import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';

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
      final isAdmin = widget.authData['isAdmin'] as bool;
      final isMock = widget.authData['isMock'] as bool? ?? false;
      final phone = widget.authData['phone'] as String? ?? '';
      try {
        if (isMock) {
          await context.read<AuthProvider>().verifyMockOtp(phone, otp, isAdmin);
        } else {
          await context.read<AuthProvider>().verifyOtp(otp, isAdmin);
        }
        if (mounted) context.go('/profile-setup');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final phone = widget.authData['phone'] ?? '+91 00000 00000';

    return Scaffold(
      appBar: AppBar(title: const Text('VERIFY ACCESS')),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.withOpacity(0.1),
                ),
                child: const Icon(Icons.security_rounded, size: 64, color: Colors.amber),
              ),
              const SizedBox(height: 32),
              Text(
                'AUTH TOKEN',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter the 6-digit secure code sent to\n$phone',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.4), height: 1.5),
              ),
              const SizedBox(height: 56),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => SizedBox(
                  width: 48,
                  height: 60,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    maxLength: 1,
                    onChanged: (text) => _onOtpDigitChange(text, index),
                    decoration: InputDecoration(
                      counterText: '',
                      fillColor: theme.cardTheme.color,
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.primaryColor, width: 2),
                      ),
                    ),
                  ),
                )),
              ),
              
              const SizedBox(height: 56),
              
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _verifyOtp,
                child: authProvider.isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('AUTHORIZE ACCESS'),
              ),
              
              const SizedBox(height: 24),
              
              TextButton(
                onPressed: () {},
                child: const Text(
                  'RESEND TOKEN',
                  style: TextStyle(color: Colors.white24, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
