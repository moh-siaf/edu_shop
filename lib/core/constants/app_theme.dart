import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  // 🔹 الثيم الفاتح
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    textTheme: const TextTheme(
      titleLarge: AppTextStyles.heading,
      bodyMedium: AppTextStyles.body,
      labelLarge: AppTextStyles.button,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );

  // 🌑 الثيم الداكن
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: AppColors.secondary,
    colorScheme: ColorScheme.dark(
      primary: AppColors.secondary,
      secondary: AppColors.accent,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    textTheme: const TextTheme(
      titleLarge: AppTextStyles.heading,
      bodyMedium: AppTextStyles.body,
      labelLarge: AppTextStyles.button,
    ),
  );
}


