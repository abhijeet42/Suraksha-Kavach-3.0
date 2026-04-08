import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primaryColor.withAlpha(20),
                    ),
                    child: Icon(Icons.shield, size: 80, color: theme.primaryColor),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to Suraksha Kavach',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Choose your entry point to the secure ecosystem.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 60),
                
                _buildRoleCard(
                  context,
                  title: 'Admin Panel',
                  subtitle: 'Create a family group, generate invite codes, and monitor family safety.',
                  icon: Icons.admin_panel_settings,
                  color: Colors.amber,
                  onTap: () => context.push('/admin-auth'),
                ),
                
                const SizedBox(height: 20),
                
                _buildRoleCard(
                  context,
                  title: 'User Panel',
                  subtitle: 'Join a family group and protect your device from phishing scams.',
                  icon: Icons.person_add_alt_1,
                  color: Colors.blueAccent,
                  onTap: () => context.push('/user-pairing'),
                ),
                
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(40), width: 2),
          gradient: LinearGradient(
            colors: [color.withAlpha(20), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
