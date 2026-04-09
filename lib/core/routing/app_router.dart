import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'main_scaffold.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/auth/presentation/screens/common/phone_auth_screen.dart';
import '../../features/auth/presentation/screens/common/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/auth_selection_screen.dart';
import '../../features/auth/presentation/screens/common/email_auth_screen.dart';
import '../../features/auth/presentation/screens/common/profile_setup_screen.dart';
import '../../features/auth/presentation/screens/user/user_pairing_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/family_shield/presentation/screens/family_dashboard_screen.dart';
import '../../features/family_shield/presentation/screens/family_member_detail_screen.dart';
import '../../features/family_shield/models/family_member.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/reporting/presentation/screens/report_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/profile_edit_screen.dart';
import '../../features/settings/presentation/screens/help_screen.dart';
import '../../features/auth/providers/auth_provider.dart';

class AppRouter {
  static GoRouter router(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final loc = state.uri.toString();
        
        final isAuthRoute = loc == '/role-selection' || 
                           loc == '/splash' || 
                           loc == '/admin-auth' || 
                           loc == '/user-pairing' || 
                           loc == '/user-auth' || 
                           loc == '/otp-verify' ||
                           loc == '/auth-selection' ||
                           loc.startsWith('/email-auth') ||
                           loc == '/profile-setup';

        // Redirect to selection if not authenticated
        if (!isLoggedIn && !isAuthRoute) return '/role-selection';
        
        // Prevent accessing login if already logged in
        if (isLoggedIn && (loc == '/role-selection' || loc == '/splash')) return '/dashboard';

        // Admin Route Guard
        if (loc == '/family-dashboard' && !authProvider.isAdmin) return '/dashboard';

        return null; // let it pass
      },
      routes: [
        GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
        GoRoute(path: '/role-selection', builder: (context, state) => const RoleSelectionScreen()),
        GoRoute(path: '/auth-selection', builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return AuthSelectionScreen(isAdmin: data['isAdmin'] ?? true);
        }),
        GoRoute(path: '/admin-auth', builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return PhoneAuthScreen(isAdmin: true, isMock: data['isMock'] ?? false);
        }),
        GoRoute(path: '/email-auth', builder: (context, state) {
          final data = state.uri.queryParameters;
          return EmailAuthScreen(isAdmin: data['isAdmin'] == 'true');
        }),
        GoRoute(path: '/user-pairing', builder: (context, state) => const UserPairingScreen()),
        GoRoute(path: '/user-auth', builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};
          return PhoneAuthScreen(isAdmin: false, isMock: data['isMock'] ?? false);
        }),
        GoRoute(path: '/otp-verify', builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return OtpVerificationScreen(authData: data);
        }),
        GoRoute(path: '/profile-setup', builder: (context, state) => const ProfileSetupScreen()),

        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
             GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
             GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
             GoRoute(path: '/family-dashboard', builder: (context, state) => const FamilyDashboardScreen()),
             GoRoute(path: '/member-detail', builder: (context, state) => FamilyMemberDetailScreen(member: state.extra as FamilyMember)),
             GoRoute(path: '/report', builder: (context, state) => const ReportScreen()),
             GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
             GoRoute(path: '/profile-edit', builder: (context, state) => const ProfileEditScreen()),
             GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
          ]
        ),
      ],
    );
  }
}
