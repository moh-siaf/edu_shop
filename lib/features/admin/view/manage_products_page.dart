// --- في ملف: lib/features/admin/products/view/pages/manage_products_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../model/product_model.dart';
import '../../../../../routes/app_routes.dart';
import '../../../model/category_model.dart';

import '../viewmodel/ManageProductsController.dart';
import '../viewmodel/manage_discounts_controller.dart';

class ManageProductsPage extends StatelessWidget {
  const ManageProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // --- منطق ذكي ومُنظَّم لقراءة الـ arguments ---
    late final CategoryModel? category;
    late final bool isSelectingForDiscount;

    if (Get.arguments is Map<String, dynamic>) {
      final arguments = Get.arguments as Map<String, dynamic>;
      category = arguments['category'] as CategoryModel?;
      isSelectingForDiscount = arguments['isSelectingForDiscount'] ?? false;
    } else if (Get.arguments is CategoryModel) {
      category = Get.arguments as CategoryModel;
      isSelectingForDiscount = false;
    } else {
      category = null;
      isSelectingForDiscount = false;
    }
    // ----------------------------------------------------

    // --- الوصول للكنترولرات ---
    final ManageProductsController manageCtrl = Get.find<ManageProductsController>();
    final ManageDiscountsController discountsCtrl = Get.find<ManageDiscountsController>();

    // --- جلب المنتجات الخاصة بالقسم المحدد ---
    // نتأكد أن category ليس null وأننا لم نقم بالجلب من قبل لنفس القسم
    if (category != null) {
      manageCtrl.fetchProductsByCategory(category.id);
    } else {
      // إذا لم يتم تحديد قسم، يمكننا جلب كل المنتجات أو عرض رسالة
      // manageCtrl.fetchAllProducts(); // افترض وجود هذه الدالة إذا أردت عرض الكل
      // حاليًا، سيعرض قائمة فارغة إذا لم يكن هناك قسم
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category != null ? 'منتجات قسم: ${category.name}' : 'إدارة المنتجات'),
        centerTitle: true,
      ),
      body: Obx(() {
        // --- استخدام القائمة الصحيحة من الكنترولر ---
        final List<ProductModel> displayProducts = manageCtrl.categoryProducts;

        if (manageCtrl.isLoading.value && displayProducts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (displayProducts.isEmpty) {
          return Center(child: Text(category != null ? 'لا توجد منتجات في هذا القسم.' : 'يرجى تحديد قسم أولاً.'));
        }

        // --- بناء قائمة المنتجات ---
        return ListView.builder(
          itemCount: displayProducts.length,
          itemBuilder: (context, index) {
            final product = displayProducts[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.pagePadding,
                vertical: AppSizes.smallSpacing,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.smallSpacing),
                child: Row(
                  children: [
                    // صورة المنتج
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: AppSizes.itemSpacing),
                    // اسم وسعر المنتج
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text('${product.price.toStringAsFixed(2)} ر.س', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary)),
                        ],
                      ),
                    ),
                    // زر التعديل/إضافة الخصم
                    IconButton(
                      icon: Icon(
                        isSelectingForDiscount ? Icons.discount_outlined : AppIcons.edit,
                        color: theme.colorScheme.secondary,
                      ),
                      onPressed: () {
                        if (isSelectingForDiscount) {
                          _showAddDiscountDialog(context, discountsCtrl, product);
                        } else {
                          Get.toNamed(Routes.addProduct, arguments: product);
                        }
                      },
                    ),
                    // زر الحذف
                    IconButton(
                      icon: Icon(AppIcons.delete, color: theme.colorScheme.error),
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'تأكيد الحذف',
                          middleText: 'هل أنت متأكد من رغبتك في حذف هذا المنتج؟',
                          textConfirm: 'حذف',
                          textCancel: 'إلغاء',
                          confirmTextColor: Colors.white,
                          onConfirm: () {
                            manageCtrl.deleteProduct(product.id);
                            Get.back();
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
          // يجب تمرير categoryId عند إضافة منتج جديد من هذه الصفحة
          Get.toNamed(Routes.addProduct, arguments: {'categoryId': category?.id});
        },
        child: const Icon(AppIcons.add),
      ),
    );
  }

  // --- دالة عرض الـ Dialog (لم تتغير) ---
  void _showAddDiscountDialog(
      BuildContext context,
      ManageDiscountsController ctrl,
      ProductModel product,
      ) {
    final formKey = GlobalKey<FormState>();
    final percentageController = TextEditingController(
      text: product.discountPercentage > 0 ? product.discountPercentage.toString() : '',
    );

    Get.defaultDialog(
      title: 'إضافة/تعديل خصم',
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('منتج: ${product.name}', style: Get.textTheme.titleMedium),
            const SizedBox(height: 16),
            TextFormField(
              controller: percentageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'نسبة الخصم (%)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'الحقل مطلوب';
                final percentage = int.tryParse(value);
                if (percentage == null || percentage <= 0 || percentage >= 100) {
                  return 'أدخل نسبة بين 1 و 99';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      textConfirm: 'حفظ',
      textCancel: 'إلغاء',
      onConfirm: () async {
        if (formKey.currentState!.validate()) {
          final percentage = int.parse(percentageController.text);
          final success = await ctrl.setProductDiscount(
            productId: product.id,
            discountPercentage: percentage,
          );

          if (success) {
            Get.back(); // إغلاق الـ Dialog
            Get.back(); // الرجوع من صفحة المنتجات
            Get.back(); // الرجوع من صفحة الأقسام
          }
        }
      },
    );
  }
}
