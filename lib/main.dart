import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/routing/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/sms_detection/providers/sms_stream_provider.dart';
import 'features/history/providers/sms_history_provider.dart';
import 'features/family_shield/providers/family_admin_provider.dart';
import 'features/family_shield/providers/family_member_provider.dart';
import 'core/database/hive_service.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/notification_service.dart';
import 'core/services/voice_service.dart';
import 'core/localization/locale_provider.dart';
import 'features/elderly_mode/providers/elderly_mode_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:suraksha_kavach/l10n/app_localizations.dart';
import 'features/reporting/providers/threat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HiveService.init();
  await NotificationService.initialize();
  await VoiceService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FamilyAdminProvider()),
        ChangeNotifierProvider(create: (_) => FamilyMemberProvider()),
        ChangeNotifierProvider(create: (_) => ElderlyModeProvider()),
        ChangeNotifierProvider(create: (_) => SmsHistoryProvider()),
        ChangeNotifierProvider(create: (_) => ThreatProvider()),
        ChangeNotifierProxyProvider<SmsHistoryProvider, SmsStreamProvider>(
          create: (_) => SmsStreamProvider(),
          update: (_, history, stream) => stream!..updateHistoryProvider(history),
        ),
      ],
      child: const SurakshaKavachApp(),
    ),
  );
}

class SurakshaKavachApp extends StatefulWidget {
  const SurakshaKavachApp({super.key});

  @override
  State<SurakshaKavachApp> createState() => _SurakshaKavachAppState();
}

class _SurakshaKavachAppState extends State<SurakshaKavachApp> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Router must be created once and stored — recreating it on every
    // build() call causes Duplicate GlobalKey / Navigator conflicts.
    _router = AppRouter.router(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp.router(
      title: 'Suraksha Kavach',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      routerConfig: _router,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],
    );
  }
}
