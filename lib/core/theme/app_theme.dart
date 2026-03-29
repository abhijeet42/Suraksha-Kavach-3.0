import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeType { amber, forest, purple, pink, white }

class AppTheme {
  static ThemeData getTheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.forest:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFF43A047),
          background: const Color(0xFF0D1B13),
          surface: const Color(0xFF1B2E24),
          accent: Colors.greenAccent,
        );
      case AppThemeType.purple:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF4A148C),
          secondary: const Color(0xFF7B1FA2),
          background: const Color(0xFF120E1A),
          surface: const Color(0xFF221634),
          accent: Colors.deepPurpleAccent,
        );
      case AppThemeType.pink:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF880E4F),
          secondary: const Color(0xFFAD1457),
          background: const Color(0xFF1A0E13),
          surface: const Color(0xFF341624),
          accent: Colors.pinkAccent,
        );
      case AppThemeType.white:
        return _buildTheme(
          brightness: Brightness.light,
          primary: const Color(0xFF212121),
          secondary: const Color(0xFFB71C1C),
          background: const Color(0xFFF5F5F5),
          surface: Colors.white,
          accent: Colors.red,
        );
      case AppThemeType.amber:
        return _buildTheme(
          brightness: Brightness.dark,
          primary: const Color(0xFFFFC107),
          secondary: const Color(0xFFFFB300),
          background: const Color(0xFF121212),
          surface: const Color(0xFF1E1E1E),
          accent: Colors.amberAccent,
        );
    }
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color background,
    required Color surface,
    required Color accent,
  }) {
    final base = brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: brightness == Brightness.dark ? Colors.white : Colors.black87,
        displayColor: brightness == Brightness.dark ? Colors.white : Colors.black,
      ),
      cardTheme: CardThemeData( // Changed to CardThemeData
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: brightness == Brightness.dark ? Colors.white10 : Colors.black12),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: brightness == Brightness.dark ? Colors.white : Colors.black),
        titleTextStyle: GoogleFonts.inter(
          color: brightness == Brightness.dark ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withAlpha(50),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: brightness == Brightness.dark ? Colors.black : Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
