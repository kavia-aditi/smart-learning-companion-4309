import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class AppTheme {
  /// Spacing scale used across the app: 8, 12, 16, 24.
  static const double sp8 = 8;
  static const double sp12 = 12;
  static const double sp16 = 16;
  static const double sp24 = 24;

  /// Corner radii
  static const double r12 = 12;
  static const double r16 = 16;

  /// Returns the Ocean Professional ThemeData for the application.
  static ThemeData theme() {
    // Color tokens
    const Color primary = Color(0xFF2563EB);
    const Color secondary = Color(0xFFF59E0B);
    const Color error = Color(0xFFEF4444);
    const Color bgCanvas = Color(0xFFF9FAFB);
    const Color surface = Color(0xFFFFFFFF);
    const Color textPrimary = Color(0xFF111827);
    const Color textMuted = Color(0xFF666A70);
    const Color border = Color(0xFFE5E7EB);
    const Color accent = Color(0xFF3B82F6);

    final ColorScheme scheme = ColorScheme(
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
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bgCanvas,
      // Typography: modern sans defaults; if GoogleFonts added later, swap here.
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.2),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.1),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    // Buttons with hover/splash and accessible sizes.
    final elevated = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: accent,
      foregroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withAlpha(18),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r12)),
      splashFactory: InkRipple.splashFactory,
    );

    final filled = FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(44),
      backgroundColor: scheme.primary.withAlpha(230),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r12)),
    );

    final outlined = OutlinedButton.styleFrom(
      minimumSize: const Size(48, 44),
      side: const BorderSide(color: border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r12)),
      foregroundColor: textPrimary,
    );

    return base.copyWith(
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimary,
        centerTitle: false,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(color: textPrimary),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 1,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withAlpha(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r12)),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
        iconColor: textPrimary,
        textColor: textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: sp16, vertical: sp12),
        hintStyle: const TextStyle(color: Color(0xFF8A8F96)),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: border),
          borderRadius: BorderRadius.circular(9999),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: border),
          borderRadius: BorderRadius.circular(9999),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent.withAlpha(255), width: 1.6),
          borderRadius: BorderRadius.circular(9999),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: error),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: border),
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? primary : border),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? primary : border),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? primary.withAlpha(60) : border.withAlpha(80)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: elevated),
      filledButtonTheme: FilledButtonThemeData(style: filled),
      outlinedButtonTheme: OutlinedButtonThemeData(style: outlined),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF7F7F8),
        selectedColor: const Color(0xFFE6F0FF),
        labelStyle: const TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.w600, fontSize: 14),
        side: const BorderSide(color: border),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primary.withAlpha(24),
        elevation: 1,
        shadowColor: Colors.black.withAlpha(12),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(color: states.contains(WidgetState.selected) ? primary : textMuted),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? primary : textMuted,
          ),
        ),
      ),
    );
  }

  /// Helper gradient used in headers or flexibleSpace.
  static Gradient headerGradient(ColorScheme cs) => LinearGradient(
        colors: [cs.primary.withAlpha(26), const Color(0xFFF9FAFB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
