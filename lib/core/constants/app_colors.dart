// --- في ملف: lib/core/constants/app_colors.dart ---

import 'package:flutter/material.dart';

class AppColors {
  // =================================================================
  // ☀️ ألوان الوضع الفاتح (Light Mode)
  // =================================================================

  // --- الألوان الأساسية ---
  static const Color lightPrimary = Color(0xFF1565C0);
  static const Color lightSecondary = Color(0xFF42A5F5);
  static const Color lightAccent = Color(0xFF1E88E5);

  // --- ألوان النصوص والخلفيات ---
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Colors.white; // للبطاقات
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);

  // --- ألوان الحالة ---
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);


  // =================================================================
  // 🌙 ألوان الوضع المظلم (Dark Mode)
  // =================================================================

  // --- الألوان الأساسية ---
  static const Color darkPrimary = Color(0xFFBB86FC);    // بنفسجي فاتح
  static const Color darkSecondary = Color(0xFF03DAC6);   // تركواز

  // --- ألوان النصوص والخلفيات ---
  static const Color darkBackground = Color(0xFF121212);   // أسود فاحم
  static const Color darkSurface = Color(0xFF1E1E1E);      // رمادي داكن للبطاقات
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.grey;


  // =================================================================
  // 🎨 ألوان التصميم الفاخر (البنفسجي) - يمكن استخدامها في أي وضع
  // =================================================================
  static const Color primaryLuxury = Color(0xFF6A1B9A);
  static const Color secondaryLuxury = Color(0xFF8E24AA);
  static const Color textLuxury = Color(0xFF333333);
}
