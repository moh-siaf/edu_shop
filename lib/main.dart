import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/app_theme.dart';
import 'firebase_options.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 تهيئة Firebase هنا قبل تشغيل التطبيق
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EduShop());
}

class EduShop extends StatelessWidget {
  const EduShop({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Edu Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: Routes.home,

      getPages: AppPages.routes,
    );
  }
}
