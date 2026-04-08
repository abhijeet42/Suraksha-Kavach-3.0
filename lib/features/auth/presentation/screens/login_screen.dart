import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 120, color: theme.primaryColor),
                    const Icon(Icons.remove_red_eye, size: 35, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 48),
                Text(
                  'Welcome Back',
                  style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to your digital shield.',
                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
                ElevatedButton.icon(
                  onPressed: () => context.push('/admin-auth'),
                  icon: const Icon(Icons.admin_panel_settings_rounded),
                  label: const Text('LOGIN AS ADMIN', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => context.push('/user-auth'),
                  icon: const Icon(Icons.person_rounded),
                  label: const Text('LOGIN AS MEMBER', style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w800)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    foregroundColor: theme.primaryColor,
                    side: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
