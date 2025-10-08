import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class AppTheme {
  /// Build the Ocean Professional light theme used across the app.
  static ThemeData light() {
    const Color primary = Color(0xFF2563EB); // Blue 600
    const Color accent = Color(0xFF3B82F6); // Blue 500
    const Color secondary = Color(0xFFF59E0B); // Amber
    const Color bgCanvas = Color(0xFFF9FAFB);
    const Color surface = Color(0xFFFFFFFF);
    const Color textPrimary = Color(0xFF111827);
    const Color textSecondary = Color(0xFF666A70);
    const Color textMuted = Color(0xFF8A8F96);
    const Color border = Color(0xFFE5E7EB);
    const Color divider = Color(0xFFECECEC);
    const Color chipBg = Color(0xFFF7F7F8);
    const Color chipText = Color(0xFF1F2937);
    const Color error = Color(0xFFEF4444);

    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    final scheme = ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: textPrimary,
      onError: Colors.white,
      tertiary: accent,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bgCanvas,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimary,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 1,
        indicatorColor: primary.withAlpha(24),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary);
          }
          return IconThemeData(color: textPrimary.withAlpha(180));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final baseStyle = const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
          if (states.contains(WidgetState.selected)) {
            return baseStyle.copyWith(color: primary);
          }
          return baseStyle.copyWith(color: textPrimary.withAlpha(160));
        }),
      ),
      dividerColor: divider,
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shadowColor: Colors.black.withAlpha(12),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: border),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.2, color: textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: textMuted),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: border),
          borderRadius: BorderRadius.circular(9999),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: border),
          borderRadius: BorderRadius.circular(9999),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent, width: 1.5),
          borderRadius: BorderRadius.circular(9999),
        ),
        hintStyle: const TextStyle(color: textMuted),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: chipBg,
        shape: StadiumBorder(side: BorderSide(color: border)),
        labelStyle: const TextStyle(
          color: chipText,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        selectedColor: const Color(0xFFE6F0FF),
        side: BorderSide(color: border),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
    );
  }
}
