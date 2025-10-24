// --- في ملف: lib/core/widgets/gradient_app_bar.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ✅ لم يعد StatelessWidget، بل دالة تُرجع SliverAppBar مباشرة
// هذا يجعله أكثر مرونة وقابلية لإعادة الاستخدام في CustomScrollView
SliverAppBar buildFlexibleAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
}) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  // --- تحديد الألوان بناءً على الثيم ---
  final List<Color> gradientColors;
  final Color iconAndTextColor;

  if (isDarkMode) {
    // الوضع الداكن
    gradientColors = [
      theme.cardColor.withOpacity(0.9),
      theme.cardColor,
    ];
    iconAndTextColor = Colors.white;
  } else {
    // الوضع الفاتح
    gradientColors = [
      Colors.grey[100]!,
      Colors.white,
    ];
    iconAndTextColor = Colors.black87;
  }

  return SliverAppBar(
    // --- خصائص المرونة والتقلص ---
    expandedHeight: 120.0, // الارتفاع عند التمدد الكامل
    floating: true,       // يظهر الشريط بمجرد التمرير للأسفل قليلاً
    pinned: true,         // يبقى الشريط العلوي ظاهرًا حتى بعد التقلص
    snap: true,           // يعود الشريط بالكامل أو يختفي بالكامل (سلوك مرن)

    // --- ✅ أهم جزء: الشكل ذو الحواف الدائرية ---
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
    ),

    automaticallyImplyLeading: false, // نزيل زر الرجوع الافتراضي لنتحكم به بأنفسنا

    // --- خلفية الشريط المرن (FlexibleSpaceBar) ---
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      titlePadding: const EdgeInsets.only(bottom: 16.0),
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          color: iconAndTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
    ),

    // --- الأيقونات والإجراءات ---
    leading: Get.previousRoute.isNotEmpty
        ? IconButton(
      icon: Icon(Icons.arrow_back_ios, color: iconAndTextColor),
      onPressed: () => Get.back(),
    )
        : null,
    actions: actions,
    actionsIconTheme: IconThemeData(color: iconAndTextColor),
  );
}
