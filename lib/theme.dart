import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF4FC3F7);
  static const sky = Color(0xFF4FC3F7);
  static const lightSky = Color(0xFFE1F5FE);
  static const green = Color(0xFF66BB6A);
  static const lightGreen = Color(0xFFE8F5E9);
  static const purple = Color(0xFFB19CD9);
  static const lightPurple = Color(0xFFF3EEFF);
  static const yellow = Color(0xFFFFD93D);
  static const lightYellow = Color(0xFFFFFDE8);
  static const coral = Color(0xFFFF8B94);
  static const orange = Color(0xFFFFB347);

  static const gradientSky = LinearGradient(
    colors: [sky, Color(0xFF29B6F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientGreen = LinearGradient(
    colors: [green, Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundGradient = LinearGradient(
    colors: [lightSky, lightGreen, lightPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.light,
      textTheme: GoogleFonts.jostTextTheme().copyWith(
        displayLarge: GoogleFonts.jost(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF333333),
        ),
        displayMedium: GoogleFonts.jost(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF333333),
        ),
        headlineLarge: GoogleFonts.jost(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF444444),
        ),
        headlineMedium: GoogleFonts.jost(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF555555),
        ),
        titleLarge: GoogleFonts.jost(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF555555),
        ),
        bodyLarge: GoogleFonts.jost(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF666666),
        ),
        bodyMedium: GoogleFonts.jost(
          fontSize: 14,
          color: const Color(0xFF888888),
        ),
        labelLarge: GoogleFonts.jost(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          textStyle: GoogleFonts.jost(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: AppColors.sky.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class LevelInfo {
  static const List<String> titles = [
    '한글 새싹',
    '한글 꿈나무',
    '한글 탐험가',
    '한글 용사',
    '한글 마법사',
    '한글 영웅',
    '한글 박사',
  ];

  static const List<String> emojis = [
    '🌱', '🌿', '🔭', '⚔️', '🧙', '🦸', '🎓',
  ];

  static const List<int> xpThresholds = [
    0, 15, 40, 80, 140, 220, 350,
  ];

  static String titleFor(int level) =>
      titles[(level - 1).clamp(0, titles.length - 1)];

  static String emojiFor(int level) =>
      emojis[(level - 1).clamp(0, emojis.length - 1)];

  static int xpForLevel(int level) =>
      xpThresholds[(level - 1).clamp(0, xpThresholds.length - 1)];

  static int xpForNextLevel(int level) {
    if (level >= xpThresholds.length) return xpThresholds.last;
    return xpThresholds[level.clamp(0, xpThresholds.length - 1)];
  }
}
