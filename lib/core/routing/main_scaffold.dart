import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CRITICAL STABILITY RULE:
//   The NavigationBar destinations list must NEVER change its item count
//   at runtime. Dynamically adding/removing items (e.g., via `if (isAdmin)`)
//   causes Flutter's internal Tooltip state (RawTooltipState) to try to
//   create multiple tickers on a SingleTickerProviderStateMixin, resulting
//   in a fatal red-screen crash.
//
//   Solution: Always render all 5 tabs. Guard navigation in onItemTapped.
// ─────────────────────────────────────────────────────────────────────────────

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;
    final location = GoRouterState.of(context).uri.toString();

    // Fixed 5-item path list — order matches destinations list below.
    // Do NOT make this conditional. See stability note above.
    const paths = [
      '/dashboard',
      '/history',
      '/family-dashboard',
      '/report',
      '/settings',
    ];

    int getIndex() {
      for (int i = 0; i < paths.length; i++) {
        if (location.startsWith(paths[i])) return i;
      }
      return 0;
    }

    void onItemTapped(int index) {
      // Non-admins may not navigate to the family tab
      if (paths[index] == '/family-dashboard' && !isAdmin) return;
      context.go(paths[index]);
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: getIndex(),
        onDestinationSelected: onItemTapped,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.family_restroom_outlined,
              // Visually dim for non-admins so they know it's inactive
              color: isAdmin ? null : Colors.white24,
            ),
            selectedIcon: const Icon(Icons.family_restroom),
            label: 'Family',
          ),
          const NavigationDestination(
            icon: Icon(Icons.report_outlined),
            selectedIcon: Icon(Icons.report),
            label: 'Report',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
