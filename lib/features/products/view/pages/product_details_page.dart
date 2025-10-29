// --- في ملف: lib/features/products/view/pages/product_details_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../model/product_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../cart/cart_controller/cart_controller.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- ✅ جلب الثيم الحالي ---
    final theme = Theme.of(context);

    // 1. استقبال البيانات وتحديد السياق
    final arguments = Get.arguments;
    final ProductModel product;
    bool isFromCart = false;
    int initialQuantity = 1;

    if (arguments is Map && arguments['source'] == 'cart') {
      product = arguments['product'];
      initialQuantity = arguments['quantity'];
      isFromCart = true;
    } else {
      product = arguments;
    }

    // 2. تهيئة الكنترولرات والكمية
    final CartController cartController = Get.find<CartController>();
    final RxInt qty = initialQuantity.obs;

    final hasDesc = !(product.description?.trim().isEmpty ?? true);
    final descText = hasDesc ? product.description!.trim() : 'لا يوجد وصف متاح لهذا المنتج.';

    return Scaffold(
      // --- ✅ استخدام لون الخلفية من الثيم ---
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // AppBar سيأخذ لونه من الثيم تلقائيًا
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Get.toNamed(Routes.cart),
          ),
        ],
        title: Text(isFromCart ? 'تعديل الكمية' : product.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- واجهة عرض المنتج ---
            // --- ✅ [مُعدل]: استخدام Stack لإضافة شارة الخصم ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                    tag: 'det_product_${product.id}',
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.broken_image, size: 64)),
                        ),
                      ),
                    ),
                  ),
                ),

                // --- شارة الخصم (تظهر فقط في حالة وجود خصم) ---
                if (product.discountPercentage > 0)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${product.discountPercentage}%',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // ✅ استخدام ستايل ولون النص من الثيم
                  child: Text(
                    product.name,
                    style: theme.textTheme.displaySmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
                // --- ✅ استبدل الجزء السابق بهذا الكود ---

                const SizedBox(width: 12),

// م
                if (product.discountPercentage <= 0)
                // اعرض السعر الأصلي فقط
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${product.price.toStringAsFixed(2)} ر.س',
                      style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.secondary),
                    ),
                  )
// إذا كان المنتج يحتوي على خصم
                else
                // اعرض السعرين (القديم والجديد)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 1. السعر القديم (مع خط في المنتصف)
                      Text(
                        '${product.price.toStringAsFixed(2)} ر.س',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      // 2. السعر الجديد (بعد الخصم)
                      Text(
                        '${product.discountPrice?.toStringAsFixed(2)} ر.س',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: const Text('متوفر'),
                  // ✅ استخدام لون الحالة من الثيم
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.08),
                  labelStyle: AppTextStyles.body.copyWith(color: theme.colorScheme.primary),
                ),
                Chip(
                  label: const Text('شحن سريع'),
                  // ✅ استخدام لون الحالة من الثيم
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.08),
                  labelStyle: AppTextStyles.body.copyWith(color: theme.colorScheme.secondary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ✅ استخدام ستايل ولون النص من الثيم
            Text('الوصف', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            // ✅ استخدام ستايل ولون النص من الثيم
            Text(descText, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),

            // --- واجهة التحكم بالسلة (ديناميكية) ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // ✅ استخدام لون البطاقة من الثيم
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Obx(() => Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (qty.value > 1) qty.value--;
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      // ✅ استخدام ستايل ولون النص من الثيم
                      Text('${qty.value}', style: theme.textTheme.titleMedium),
                      IconButton(
                        onPressed: () => qty.value++,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  )),
                  const Spacer(),
                  // ElevatedButton سيأخذ ستايله من الثيم تلقائيًا
                  if (isFromCart)
                    ElevatedButton.icon(
                      onPressed: () {
                        cartController.updateQuantity(product.id, qty.value);
                        Get.back();
                        Get.snackbar('تم الحفظ', 'تم تحديث الكمية بنجاح');
                      },
                      icon: const Icon(Icons.save_as_outlined),
                      label: const Text('حفظ'),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () {
                        cartController.addToCart(product, quantity: qty.value);
                        Get.snackbar(
                          'تمت الإضافة',
                          'أُضيف ${product.name} (${qty.value}x) إلى السلة',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('أضِف إلى السلة'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- زر المشاركة ---
            OutlinedButton.icon(
              onPressed: () {
                Get.snackbar('مشاركة', 'تم نسخ رابط المنتج (عرض تجريبي)',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2));
              },
              icon: const Icon(Icons.share_outlined),
              label: const Text('مشاركة المنتج'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                // ✅ استخدام لون النص الأساسي من الثيم
                foregroundColor: theme.colorScheme.primary,
                // ✅ استخدام لون حدود من الثيم
                side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
