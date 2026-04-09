import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthSelectionScreen extends StatefulWidget {
  final bool isAdmin;
  const AuthSelectionScreen({super.key, required this.isAdmin});

  @override
  State<AuthSelectionScreen> createState() => _AuthSelectionScreenState();
}

class _AuthSelectionScreenState extends State<AuthSelectionScreen> {
  bool _showMethods = false;
  String _type = 'login'; // login or register

  void _selectType(String type) {
    setState(() {
      _type = type;
      _showMethods = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.isAdmin ? 'Admin Portal' : 'User Portal';

    return Scaffold(
      appBar: AppBar(title: Text(title.toUpperCase())),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                _showMethods ? 'CHOOSE METHOD' : (_type == 'login' ? 'WELCOME BACK' : 'GET STARTED'),
                style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _showMethods 
                  ? 'How would you like to verify your identity?'
                  : (widget.isAdmin 
                      ? 'Secure access to your family guard command center.'
                      : 'Join your family network for real-time protection.'),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
              const SizedBox(height: 60),

              if (!_showMethods) ...[
                _buildOptionCard(
                  title: 'LOG IN',
                  subtitle: 'Access your existing account securely.',
                  icon: Icons.login_rounded,
                  color: Colors.amber,
                  onTap: () => _selectType('login'),
                ),
                const SizedBox(height: 20),
                _buildOptionCard(
                  title: 'REGISTER',
                  subtitle: 'Create a new security node for your family.',
                  icon: Icons.app_registration_rounded,
                  color: Colors.greenAccent,
                  onTap: () => _selectType('register'),
                ),
              ] else ...[
                _buildOptionCard(
                  title: 'PHONE NUMBER',
                  subtitle: 'Verify using a secure SMS OTP code.',
                  icon: Icons.phone_android_rounded,
                  color: Colors.blueAccent,
                  onTap: () => context.push(widget.isAdmin ? '/admin-auth' : '/user-auth'),
                ),
                const SizedBox(height: 20),
                _buildOptionCard(
                  title: 'EMAIL ADDRESS',
                  subtitle: 'Secure authentication via email verification.',
                  icon: Icons.email_rounded,
                  color: Colors.purpleAccent,
                  onTap: () => context.push('/email-auth?isAdmin=${widget.isAdmin}'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => _showMethods = false),
                  child: const Text('GO BACK', style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF14171E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4))),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
