import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _voiceAlertsEnabled = false;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to disconnect your digital shield?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
            }, 
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: ListView(
          children: [
            // Profile Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.primaryColor.withAlpha(150)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white24,
                  radius: 32,
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Abhijith', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('System Role: ${authProvider.isAdmin ? "Family Admin" : "Family Member"}', style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Galaxy Themes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildThemeCard(context, themeProvider, AppThemeType.amber, 'Amber', Colors.amber),
                _buildThemeCard(context, themeProvider, AppThemeType.forest, 'Forest', Colors.green),
                _buildThemeCard(context, themeProvider, AppThemeType.purple, 'Purple', Colors.purple),
                _buildThemeCard(context, themeProvider, AppThemeType.pink, 'Pink', Colors.pink),
                _buildThemeCard(context, themeProvider, AppThemeType.white, 'White', Colors.grey),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('App Preferences', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Alerts for new threat interceptions'),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            secondary: const Icon(Icons.notifications_active),
          ),
          SwitchListTile(
            title: const Text('Voice Alerts (Accessibility)'),
            subtitle: const Text('Read out threat warnings out loud'),
            value: _voiceAlertsEnabled,
            onChanged: (val) => setState(() => _voiceAlertsEnabled = val),
            secondary: const Icon(Icons.record_voice_over),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            onTap: () => context.push('/profile-edit'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () => context.push('/help'),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Text('English', style: TextStyle(color: Colors.grey)),
            onTap: () {},
          ),
          
          const Divider(height: 32),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text('Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          
          _buildLogoutItem(context),
          const SizedBox(height: 40),
        ],
      ),
    ),
  );
}

  Widget _buildThemeCard(BuildContext context, ThemeProvider provider, AppThemeType type, String name, Color color) {
    final isSelected = provider.currentTheme == type;
    return GestureDetector(
      onTap: () => provider.setTheme(type),
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
          color: color.withAlpha(isSelected ? 50 : 20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
            const SizedBox(height: 8),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Logout', style: TextStyle(color: Colors.red)),
      onTap: () => _showLogoutDialog(context),
    );
  }
}
