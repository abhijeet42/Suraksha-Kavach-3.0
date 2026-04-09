import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:suraksha_kavach/features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/data/models/user_role.dart';
import 'package:suraksha_kavach/features/family_shield/providers/family_member_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();

  void _onComplete() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a display name')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    authProvider.updateDisplayName(_nameController.text);
    
    // If it's a member, trigger the LAN join now with the user's name
    if (authProvider.role == UserRole.member) {
      await context.read<FamilyMemberProvider>().joinFamily(_nameController.text);
    }

    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeIn(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.face_retouching_natural_rounded, size: 100, color: Colors.amber),
              const SizedBox(height: 32),
              Text(
                'WHAT IS YOUR NAME?',
                style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'This name will identify your device in the family network.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Enter Display Name',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.1)),
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber.withOpacity(0.3))),
                ),
              ),
              const SizedBox(height: 56),
              ElevatedButton(
                onPressed: _onComplete,
                child: const Text('COMPLETE SETUP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
