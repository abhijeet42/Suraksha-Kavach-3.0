import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isAuthenticated) {
        context.go('/dashboard');
      } else {
        context.go('/role-selection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep Obsidian Black
      body: FadeIn(
        duration: const Duration(milliseconds: 1500),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shield Icon with smooth glow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.15),
                      blurRadius: 50,
                      spreadRadius: 20,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  size: 140,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 56),
              // Premium Typography
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0), // Compensate for trailing letter spacing
                    child: Text(
                      'SURAKSHA KAVACH',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        letterSpacing: 8,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.amber.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'INDIAS CYBERSHIELD ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      letterSpacing: 4,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              // Smooth Spinner
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.amber.withOpacity(0.5)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'INITIALIZING SECURE MESH',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  letterSpacing: 2,
                  color: Colors.white12,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

