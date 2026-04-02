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
    '한글 새싹',       // Lv1 - 0 XP
    '한글 씨앗',       // Lv2 - 20 XP
    '한글 풀잎',       // Lv3 - 50 XP
    '한글 꿈나무',     // Lv4 - 100 XP
    '한글 탐험가',     // Lv5 - 180 XP
    '한글 모험가',     // Lv6 - 300 XP
    '한글 용사',       // Lv7 - 470 XP
    '한글 기사',       // Lv8 - 700 XP
    '한글 마법사',     // Lv9 - 1000 XP
    '한글 현자',       // Lv10 - 1400 XP
    '한글 영웅',       // Lv11 - 1900 XP
    '한글 전설',       // Lv12 - 2500 XP
    '한글 수호자',     // Lv13 - 3300 XP
    '한글 대마법사',   // Lv14 - 4300 XP
    '한글 챔피언',     // Lv15 - 5500 XP
    '한글 마스터',     // Lv16 - 7000 XP
    '한글 그랜드마스터', // Lv17 - 9000 XP
    '한글 왕',         // Lv18 - 11500 XP
    '한글 황제',       // Lv19 - 15000 XP
    '한글 신',         // Lv20 - 20000 XP
  ];

  static const List<String> emojis = [
    '🌱', '🫘', '🌿', '🌴', '🔭',
    '🧭', '⚔️', '🛡️', '🧙', '📜',
    '🦸', '🌟', '🏰', '🔮', '🏆',
    '👨‍🎓', '⭐', '👑', '🏛️', '✨',
  ];

  static const List<int> xpThresholds = [
    0, 20, 50, 100, 180,
    300, 470, 700, 1000, 1400,
    1900, 2500, 3300, 4300, 5500,
    7000, 9000, 11500, 15000, 20000,
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
