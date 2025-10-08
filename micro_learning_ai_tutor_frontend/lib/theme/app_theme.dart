import 'package:flutter/material.dart';

/* PUBLIC_INTERFACE */ 
/// Gradient helpers for Ocean Professional look.
/// Provides subtle gradients used for headers and backgrounds.
class OceanGradients {
  /// Creates an instance of [OceanGradients].
  const OceanGradients();

  /// Subtle top-to-bottom blue to gray gradient (from-blue-500/10 to-gray-50).
  LinearGradient get subtleVertical => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x1A3B82F6), // Blue-500 @ 10%
          Color(0xFFFFFAFA), // near-gray-50 off-white
        ],
      );

  /// Subtle diagonal gradient for headers/hero.
  LinearGradient get subtleDiagonal => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x1A3B82F6),
          Color(0xFFFFFAFA),
        ],
      );
}

/// PUBLIC_INTERFACE
class AppTheme {
  /// Expose gradient utilities to the app.
  static const OceanGradients _gradients = OceanGradients();

  /// PUBLIC_INTERFACE
  /// Accessor for subtle gradients used in headers/containers.
  static OceanGradients gradients() => _gradients;

  /// PUBLIC_INTERFACE
  /// Build the Ocean Professional light theme used across the app.
  static ThemeData light() {
    // Tokens
    const Color primary = Color(0xFF2563EB); // Blue 600
    const Color secondary = Color(0xFFF59E0B); // Amber
    const Color accent = Color(0xFF3B82F6); // Blue 500
    const Color error = Color(0xFFEF4444);

    const Color bgCanvas = Color(0xFFF9FAFB);
    const Color surface = Color(0xFFFFFFFF);

    const Color textPrimary = Color(0xFF111827);
    const Color textSecondary = Color(0xFF666A70);
    const Color textMuted = Color(0xFF8A8F96);

    const Color border = Color(0xFFE5E7EB);
    const Color divider = Color(0xFFECECEC);

    const Color chipBg = Color(0xFFF7F7F8);
    const Color chipText = Color(0xFF1F2937);

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    final scheme = ColorScheme(
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
      onTertiary: Colors.white,
      surfaceContainerHighest: const Color(0xFFF3F4F6),
      surfaceContainerHigh: const Color(0xFFF5F6FA),
      surfaceContainer: const Color(0xFFF7F8FA),
      surfaceContainerLow: const Color(0xFFF8F9FB),
      surfaceContainerLowest: bgCanvas,
      outline: border,
      shadow: Colors.black.withAlpha(26),
      scrim: Colors.black.withAlpha(64),
      primaryContainer: const Color(0xFFE6F0FF),
      onPrimaryContainer: primary,
      secondaryContainer: const Color(0xFFFFF4DF),
      onSecondaryContainer: secondary,
    );

    // Typography with readable weights
    const textTheme = TextTheme(
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: textPrimary,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMuted,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );

    // Rounded corners and subtle shadows
    final cardShape12 = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: border),
    );

    final elevatedButtonShape12 = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: bgCanvas,
      textTheme: textTheme,

      // AppBar: minimalist, transparent with subtle elevation on scroll
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),

      // BottomNavigationBar (Material 3 NavigationBar in code uses this theme)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 1,
        indicatorColor: primary.withAlpha(24),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withAlpha(20),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary);
          }
          return IconThemeData(color: textPrimary.withAlpha(170));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final baseStyle =
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
          if (states.contains(WidgetState.selected)) {
            return baseStyle.copyWith(color: primary);
          }
          return baseStyle.copyWith(color: textPrimary.withAlpha(150));
        }),
      ),

      // Cards
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shadowColor: Colors.black.withAlpha(16),
        surfaceTintColor: Colors.transparent,
        shape: cardShape12,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.black.withAlpha(24),
          minimumSize: const Size.fromHeight(48),
          shape: elevatedButtonShape12,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: chipBg,
        selectedColor: const Color(0xFFE6F0FF),
        disabledColor: chipBg,
        shape: StadiumBorder(side: BorderSide(color: border)),
        side: BorderSide(color: border),
        labelStyle: const TextStyle(
          color: chipText,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(color: textMuted),
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
      ),

      // Dividers
      dividerColor: divider,
    );
  }
}
