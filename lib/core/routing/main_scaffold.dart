import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final location = GoRouterState.of(context).uri.toString();

    int getIndex() {
      if (location.startsWith('/dashboard')) return 0;
      if (location.startsWith('/history')) return 1;
      if (isAdmin) {
        if (location.startsWith('/family-dashboard')) return 2;
        if (location.startsWith('/report')) return 3;
        if (location.startsWith('/settings')) return 4;
      } else {
        if (location.startsWith('/report')) return 2;
        if (location.startsWith('/settings')) return 3;
      }
      return 0; // fallback
    }

    void onItemTapped(int index) {
      if (index == 0) context.go('/dashboard');
      if (index == 1) context.go('/history');
      if (isAdmin) {
        if (index == 2) context.go('/family-dashboard');
        if (index == 3) context.go('/report');
        if (index == 4) context.go('/settings');
      } else {
        if (index == 2) context.go('/report');
        if (index == 3) context.go('/settings');
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: getIndex(),
        onDestinationSelected: onItemTapped,
        destinations: [
          const NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
          const NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history), label: 'History'),
          if (isAdmin)
             const NavigationDestination(icon: Icon(Icons.family_restroom_outlined), selectedIcon: Icon(Icons.family_restroom), label: 'Family'),
          const NavigationDestination(icon: Icon(Icons.report_outlined), selectedIcon: Icon(Icons.report), label: 'Report'),
          const NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
