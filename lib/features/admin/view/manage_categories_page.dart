// --- في ملف: lib/features/admin/categories/view/pages/manage_categories_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../model/category_model.dart';
import '../../../../../routes/app_routes.dart';
import '../../categories/viewmodel/category_controller.dart';

class ManageCategoriesPage extends StatelessWidget {
  const ManageCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // نستخدم find للعثور على الكنترولر الموجود بالفعل
    final CategoryController categoryCtrl = Get.find<CategoryController>();
    final arguments = Get.arguments as Map<String, dynamic>?;
    final bool isSelectingForDiscount = arguments?['isSelectingForDiscount'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(isSelectingForDiscount ? 'اختر قسم المنتج' : 'إدارة الأقسام'),
        centerTitle: true,

      ),
      body: Obx(() {
        if (categoryCtrl.isLoading.value && categoryCtrl.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (categoryCtrl.categories.isEmpty) {
          return const Center(child: Text('لا توجد أقسام لعرضها.'));
        }
        return ListView.builder(
          itemCount: categoryCtrl.categories.length,
          itemBuilder: (context, index) {
            final category = categoryCtrl.categories[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.pagePadding,
                vertical: AppSizes.smallSpacing,
              ),
              child: ListTile(
                // صورة القسم
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                  child: CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                // اسم القسم
                title: Text(category.name, style: theme.textTheme.titleMedium),
                // عند الضغط على العنصر نفسه، ننتقل لإدارة منتجاته
                onTap: () {
                  Get.toNamed(
                    Routes.manageProducts,
                    arguments: {
                      'category': category,
                      'isSelectingForDiscount': isSelectingForDiscount,
                    },
                  );
                },
                // أزرار الإدارة
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(AppIcons.edit, color: theme.colorScheme.secondary, size: 20),
                      onPressed: () {
                        // الانتقال إلى صفحة تعديل القسم
                        Get.toNamed(Routes.addCategory, arguments: category);
                      },
                    ),
                    IconButton(
                      icon: Icon(AppIcons.delete, color: theme.colorScheme.error, size: 20),
                      onPressed: () {
                        // إظهار مربع حوار للتأكيد قبل الحذف
                        Get.defaultDialog(
                          title: 'تأكيد الحذف',
                          middleText: 'هل أنت متأكد من رغبتك في حذف هذا القسم؟ سيتم حذف جميع المنتجات التابعة له أيضًا.',
                          textConfirm: 'حذف',
                          textCancel: 'إلغاء',
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            // categoryCtrl.deleteCategory(category.id); // سنحتاج لتطوير هذه الدالة لاحقًا
                            Get.back();
                            Get.snackbar('قيد الإنشاء', 'سيتم تفعيل الحذف قريبًا');
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // الانتقال إلى صفحة إضافة قسم جديد
          Get.toNamed(Routes.addProduct);
        },
        child: const Icon(AppIcons.add),
      ),
    );
  }
}
