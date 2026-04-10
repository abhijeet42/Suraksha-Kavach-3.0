import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

class PhoneAuthScreen extends StatefulWidget {
  final bool isAdmin;
  final bool isMock;
  const PhoneAuthScreen({super.key, required this.isAdmin, this.isMock = false});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  bool _isSignUp = true;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    // Ensure phone number is in international format if not already
    final formattedPhone = phone.startsWith('+') ? phone : '+91$phone';

    if (widget.isMock) {
      context.read<AuthProvider>().sendMockOtp(formattedPhone, widget.isAdmin).then((_) {
        context.push('/otp-verify', extra: {
          'phone': formattedPhone,
          'isAdmin': widget.isAdmin,
          'isSignUp': _isSignUp,
          'isMock': true,
        });
      });
      return;
    }

    context.read<AuthProvider>().sendOtp(
      formattedPhone,
      widget.isAdmin,
      onCodeSent: (verificationId) {
        context.push('/otp-verify', extra: {
          'phone': formattedPhone,
          'isAdmin': widget.isAdmin,
          'isSignUp': _isSignUp,
        });
      },
      onError: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;
    final title = widget.isAdmin ? l10n.adminPortal : l10n.userPortal;

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
                _isSignUp ? l10n.secureAccount : l10n.systemLogin,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.enterPhone,
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
              ),
              const SizedBox(height: 48),
              
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                  prefixIcon: const Icon(Icons.phone_iphone_rounded),
                  hintText: '+91 00000 00000',
                  fillColor: theme.cardTheme.color,
                ),
              ),
              
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _sendOtp,
                child: authProvider.isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(l10n.getOtp),
              ),
              
              const SizedBox(height: 24),
              
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(
                    _isSignUp ? l10n.alreadyRegistered : l10n.newAdmin,
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
