// --- في ملف: lib/features/admin/view/pages/admin_dashboard_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/gradient_app_bar.dart';
import '../../../../routes/app_routes.dart';
import '../viewmodel/admin_dashboard_controller.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // استخدام Get.put لإنشاء الكنترولر
    final AdminDashboardController controller = Get.put(AdminDashboardController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // --- ✅ الكود الصحيح ✅ ---
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary, // استخدام اللون الأساسي من الثيم
        foregroundColor: theme.colorScheme.onPrimary, // لون النص والأيقونات فوق اللون الأساسي
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        children: [
          _buildDashboardCard(
            context: context,
            icon: AppIcons.allProducts,
            title: 'إدارة المنتجات',
            subtitle: 'إضافة، تعديل، وحذف المنتجات',
            onTap: () {
              Get.toNamed(Routes.manageProducts);
            },
          ),
          _buildDashboardCard(
            context: context,
            icon: AppIcons.search,
            title: 'إدارة الأقسام',
            subtitle: 'إضافة، تعديل، وحذف الأقسام',
            onTap: () {
              // سيتم لاحقًا التوجيه إلى صفحة إدارة الأقسام
              Get.toNamed(Routes.manageCategories);
            },
          ),
          _buildDashboardCard(
            context: context,
            icon: AppIcons.offers,
            title: 'إدارة العروض والإعلانات',
            subtitle: 'التحكم في البانرات والعروض الخاصة',
            onTap: () {
              // سيتم لاحقًا التوجيه إلى صفحة إدارة العروض
              Get.toNamed(Routes.offersDashboard);
            },
          ),
          _buildDashboardCard(
            context: context,
            icon: Icons.bar_chart_rounded,
            title: 'الإحصائيات والتقارير',
            subtitle: 'عرض أداء المتجر والمبيعات',
            onTap: () {
              Get.snackbar('قيد الإنشاء', 'سيتم بناء هذه الصفحة قريبًا');
            },
          ),
        ],
      ),
    );
  }

  /// دالة مساعدة لبناء بطاقة خيار في لوحة التحكم
  Widget _buildDashboardCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.itemSpacing),
      elevation: 2,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, size: 32, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleMedium),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
