import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.navHistory,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.family_restroom_outlined,
              // Visually dim for non-admins so they know it's inactive
              color: isAdmin ? null : Colors.white24,
            ),
            selectedIcon: const Icon(Icons.family_restroom),
            label: l10n.navFamily,
          ),
          NavigationDestination(
            icon: const Icon(Icons.report_outlined),
            selectedIcon: const Icon(Icons.report),
            label: l10n.navReport,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
