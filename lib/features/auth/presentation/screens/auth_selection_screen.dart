import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final title = widget.isAdmin ? l10n.adminPortal : l10n.userPortal;

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
                _showMethods ? l10n.chooseMethod : (_type == 'login' ? l10n.welcomeBack : l10n.getStarted),
                style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _showMethods 
                  ? l10n.howToVerify
                  : (widget.isAdmin 
                      ? l10n.adminAuthDesc
                      : l10n.userAuthDesc),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
              const SizedBox(height: 60),

              if (!_showMethods) ...[
                _buildOptionCard(
                  title: l10n.login,
                  subtitle: l10n.loginDesc,
                  icon: Icons.login_rounded,
                  color: Colors.amber,
                  onTap: () => _selectType('login'),
                ),
                const SizedBox(height: 20),
                _buildOptionCard(
                  title: l10n.register,
                  subtitle: l10n.registerDesc,
                  icon: Icons.app_registration_rounded,
                  color: Colors.greenAccent,
                  onTap: () => _selectType('register'),
                ),
              ] else ...[
                _buildOptionCard(
                  title: l10n.phoneNumber,
                  subtitle: l10n.phoneDesc,
                  icon: Icons.phone_android_rounded,
                  color: Colors.blueAccent,
                  onTap: () => context.push(widget.isAdmin ? '/admin-auth' : '/user-auth'),
                ),
                const SizedBox(height: 20),
                _buildOptionCard(
                  title: l10n.emailAddress,
                  subtitle: l10n.emailDesc,
                  icon: Icons.email_rounded,
                  color: Colors.purpleAccent,
                  onTap: () => context.push('/email-auth?isAdmin=${widget.isAdmin}'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => _showMethods = false),
                  child: Text(l10n.goBack, style: const TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 1)),
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
