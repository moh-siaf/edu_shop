// --- في ملف: lib/core/constants/app_text_styles.dart ---

import 'package:flutter/material.dart';

class AppTextStyles {
  // =================================================================
  // 🎨 الستايلات الأساسية (ستتكيف تلقائيًا مع الوضع الفاتح/المظلم)
  // =================================================================
  // ملاحظة: لم نحدد لونًا هنا، سيتم أخذه من الثيم مباشرة

  static const TextStyle heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white, // لون نص الأزرار غالبًا ما يكون ثابتًا
  );

  // =================================================================
  // 💎 ستايلات التصميم الفاخر (البنفسجي) - يمكن استخدامها في أي وضع
  // =================================================================
  // هذه الستايلات لها ألوان ثابتة خاصة بها

  static TextStyle get sectionTitleLuxury => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF333333), // AppColors.textLuxury
  );

  static TextStyle get viewAllLuxury => const TextStyle(
    color: Color(0xFF8E24AA), // AppColors.secondaryLuxury
    fontWeight: FontWeight.w600,
  );
}
