import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/core/theme/theme_provider.dart';
import 'package:suraksha_kavach/core/theme/app_theme.dart';
import 'package:suraksha_kavach/core/localization/locale_provider.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _voiceAlertsEnabled = false;

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.areYouSureLogout),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
            }, 
            child: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.read<LocaleProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.english),
              trailing: localeProvider.locale.languageCode == 'en' ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
              onTap: () {
                localeProvider.setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: Text(l10n.hindi),
              trailing: localeProvider.locale.languageCode == 'hi' ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
              onTap: () {
                localeProvider.setLocale(const Locale('hi'));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
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
                      Text(authProvider.user?.displayName ?? l10n.systemUser, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(l10n.roleLabel(authProvider.isAdmin ? l10n.familyAdmin : l10n.familyMember), style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.galaxyThemes, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
               children: [
                _buildThemeCard(context, themeProvider, AppThemeType.amber, l10n.themeAmber, Colors.amber),
                _buildThemeCard(context, themeProvider, AppThemeType.forest, l10n.themeForest, Colors.green),
                _buildThemeCard(context, themeProvider, AppThemeType.purple, l10n.themePurple, Colors.purple),
                _buildThemeCard(context, themeProvider, AppThemeType.pink, l10n.themePink, Colors.pink),
                _buildThemeCard(context, themeProvider, AppThemeType.white, l10n.themeWhite, Colors.grey),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(l10n.appPreferences, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          
          SwitchListTile(
            title: Text(l10n.pushNotifications),
            subtitle: Text(l10n.notificationsAlertsDesc),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            secondary: const Icon(Icons.notifications_active),
          ),
          SwitchListTile(
            title: Text(l10n.voiceAlerts),
            subtitle: Text(l10n.voiceAlertsDesc),
            value: _voiceAlertsEnabled,
            onChanged: (val) => setState(() => _voiceAlertsEnabled = val),
            secondary: const Icon(Icons.record_voice_over),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(l10n.editProfile),
            onTap: () => context.push('/profile-edit'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.notifications),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.helpSupport),
            onTap: () => context.push('/help'),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: Text(localeProvider.languageName, style: const TextStyle(color: Colors.grey)),
            onTap: () => _showLanguageDialog(context),
          ),
          
          const Divider(height: 32),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Text(l10n.account, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          
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
    final l10n = AppLocalizations.of(context)!;
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
      onTap: () => _showLogoutDialog(context),
    );
  }
}
