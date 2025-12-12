import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFFA855F7); // Purple
  static const Color accentColor = Color(0xFFEC4899); // Pink
  static const Color successColor = Color(0xFF10B981); // Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red

  static const Color darkBgPrimary = Color(0xFF0F172A);
  static const Color darkBgSecondary = Color(0xFF1E293B);
  static const Color darkBgTertiary = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  static const Color lightBgPrimary = Color(0xFFFAFAFA);
  static const Color lightBgSecondary = Color(0xFFF5F5F5);
  static const Color lightBgTertiary = Color(0xFFEFEFEF);
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBgPrimary,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: lightBgSecondary,
        error: errorColor,
      ),
      textTheme: _buildTextTheme(
        headlineLarge: const TextStyle(
          color: lightTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: const TextStyle(
          color: lightTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: const TextStyle(
          color: lightTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: const TextStyle(
          color: lightTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: const TextStyle(
          color: lightTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: const TextStyle(
          color: lightTextPrimary,
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: const TextStyle(
          color: lightTextSecondary,
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelSmall: const TextStyle(
          color: lightTextSecondary,
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: lightBgPrimary,
        foregroundColor: lightTextPrimary,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightBgTertiary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: lightTextSecondary),
        labelStyle: const TextStyle(color: lightTextPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: darkBgSecondary,
        error: errorColor,
      ),
      textTheme: _buildTextTheme(
        headlineLarge: const TextStyle(
          color: darkTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: const TextStyle(
          color: darkTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: const TextStyle(
          color: darkTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: const TextStyle(
          color: darkTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: const TextStyle(
          color: darkTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: const TextStyle(
          color: darkTextPrimary,
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: const TextStyle(
          color: darkTextSecondary,
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelSmall: const TextStyle(
          color: darkTextSecondary,
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: darkBgPrimary,
        foregroundColor: darkTextPrimary,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: darkBgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkBgTertiary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: darkTextSecondary),
        labelStyle: const TextStyle(color: darkTextPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme({
    required TextStyle headlineLarge,
    required TextStyle headlineMedium,
    required TextStyle headlineSmall,
    required TextStyle titleLarge,
    required TextStyle titleMedium,
    required TextStyle bodyLarge,
    required TextStyle bodyMedium,
    required TextStyle labelSmall,
  }) {
    return TextTheme(
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      labelSmall: labelSmall,
    );
  }
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFF6366F1)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFCD34D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFF87171)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
