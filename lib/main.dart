// --- في ملف: main.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'core/constants/app_theme.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  // --- التهيئة الأساسية ---
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  // --- (معطل مؤقتًا) حقن AuthController في الذاكرة بشكل دائم ---
  // Get.put(AuthController(), permanent: true);

  runApp(const EduShop());
}

class EduShop extends StatelessWidget {
  const EduShop({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Edu Shop',
      debugShowCheckedModeBanner: false,

      // --- ✅ إعدادات الثيم الصحيحة ---
      theme: AppTheme.light,       // الثيم الذي سيستخدم في الوضع الفاتح
      darkTheme: AppTheme.dark,    // الثيم الذي سيستخدم في الوضع المظلم
      themeMode: ThemeMode.system, // دع نظام التشغيل يقرر تلقائيًا

      // --- الصفحة المبدئية (للتصميم والتجربة) ---
      initialRoute: Routes.home,

      getPages: AppPages.routes,
    );
  }
}
