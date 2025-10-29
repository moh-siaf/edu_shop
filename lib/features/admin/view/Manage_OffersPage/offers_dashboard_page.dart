// --- في ملف: lib/features/admin/view/pages/offers_dashboard_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ❌ لا نحتاج لاستيراد AppIcons بعد الآن
// import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../routes/app_routes.dart';

class OffersDashboardPage extends StatelessWidget {
  const OffersDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('العروض والتخفيضات'),
        centerTitle: true,
      ),

    );
  }
}
