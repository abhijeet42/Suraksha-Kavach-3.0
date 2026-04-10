import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.nameEmptyError)),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    await authProvider.updateDisplayName(name);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfileHeader)),
      body: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Hero(
                tag: 'profile_avatar',
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Icon(Icons.person_rounded, size: 64, color: theme.primaryColor),
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.fullName,
                  labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                  prefixIcon: const Icon(Icons.badge_rounded),
                  fillColor: theme.cardTheme.color,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                enabled: false, // Don't allow phone edit in this demo sync
                decoration: InputDecoration(
                  labelText: l10n.contactInfoAuth,
                  labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal, letterSpacing: 1, color: Colors.white24),
                  prefixIcon: const Icon(Icons.phone_iphone_rounded, color: Colors.white24),
                  fillColor: theme.cardTheme.color?.withOpacity(0.5),
                ),
                style: const TextStyle(color: Colors.white24),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _saveProfile,
                child: authProvider.isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(l10n.saveChanges),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
