import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/sms_detection/providers/sms_stream_provider.dart';
import 'features/history/providers/sms_history_provider.dart';
import 'features/family_shield/providers/family_provider.dart';
import 'core/database/hive_service.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FamilyProvider()),
        ChangeNotifierProvider(create: (_) => SmsHistoryProvider()),
        ChangeNotifierProxyProvider<SmsHistoryProvider, SmsStreamProvider>(
          create: (_) => SmsStreamProvider(),
          update: (_, history, stream) => stream!..updateHistoryProvider(history),
        ),
      ],
      child: const SurakshaKavachApp(),
    ),
  );
}

class SurakshaKavachApp extends StatelessWidget {
  const SurakshaKavachApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final router = AppRouter.router(context);

    return MaterialApp.router(
      title: 'Suraksha Kavach',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      routerConfig: router,
    );
  }
}
