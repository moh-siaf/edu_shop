// --- في ملف: lib/core/constants/app_theme.dart ---

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // =================================================================
  // ☀️ الثيم الفاتح (Light Theme)
  // =================================================================
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface, // لون البطاقات
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: AppColors.lightTextPrimary,
      onSurface: AppColors.lightTextPrimary, // لون النص فوق البطاقات
      error: AppColors.error,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    cardTheme: CardTheme(
      color: AppColors.lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.heading,
      displayMedium: AppTextStyles.heading,
      displaySmall: AppTextStyles.heading,
      headlineLarge: AppTextStyles.heading,
      headlineMedium: AppTextStyles.heading,
      headlineSmall: AppTextStyles.heading,
      titleLarge: AppTextStyles.subheading, // كان heading
      titleMedium: AppTextStyles.subheading,
      titleSmall: AppTextStyles.subheading,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.body,
      labelLarge: AppTextStyles.button,
    ).apply( // تطبيق الألوان الافتراضية للنصوص
      bodyColor: AppColors.lightTextSecondary,
      displayColor: AppColors.lightTextPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );

  // =================================================================
  // 🌙 الثيم المظلم (Dark Theme)
  // =================================================================
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface, // لون البطاقات
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: AppColors.darkTextPrimary,
      onSurface: AppColors.darkTextPrimary, // لون النص فوق البطاقات
   //   error: AppColors.darkError,
      onError: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: AppColors.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.heading,
      displayMedium: AppTextStyles.heading,
      displaySmall: AppTextStyles.heading,
      headlineLarge: AppTextStyles.heading,
      headlineMedium: AppTextStyles.heading,
      headlineSmall: AppTextStyles.heading,
      titleLarge: AppTextStyles.subheading,
      titleMedium: AppTextStyles.subheading,
      titleSmall: AppTextStyles.subheading,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.body,
      labelLarge: AppTextStyles.button,
    ).apply( // تطبيق الألوان الافتراضية للنصوص
      bodyColor: AppColors.darkTextSecondary,
      displayColor: AppColors.darkTextPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}
