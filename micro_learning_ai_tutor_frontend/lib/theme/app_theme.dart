import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class AppTheme {
  /// Returns the Ocean Professional ThemeData for the application.
  static ThemeData theme() {
    const Color primary = Color(0xFF2563EB);
    const Color secondary = Color(0xFFF59E0B);
    const Color error = Color(0xFFEF4444);
    const Color bgCanvas = Color(0xFFF9FAFB);
    const Color surface = Color(0xFFFFFFFF);
    const Color textPrimary = Color(0xFF111827);
    const Color accent = Color(0xFF3B82F6);

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.black,
        error: error,
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        tertiary: accent,
      ),
      scaffoldBackgroundColor: bgCanvas,
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.2),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimary,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(9999),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(9999),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: accent, width: 1.5),
          borderRadius: BorderRadius.circular(9999),
        ),
        hintStyle: const TextStyle(color: Color(0xFF8A8F96)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0.8,
          shadowColor: Colors.black.withAlpha(20),
          minimumSize: const Size.fromHeight(48),
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF7F7F8),
        selectedColor: const Color(0xFFE6F0FF),
        labelStyle: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w600, fontSize: 14),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
    );
  }
}
