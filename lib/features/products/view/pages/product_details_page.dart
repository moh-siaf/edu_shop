import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../model/product_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../cart/cart_controller/cart_controller.dart';
import '../../viewmodel/products_controller.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      isFromCart = false;
    }

    // 2. تهيئة الكنترولرات والكمية
    final CartController cartController = Get.find<CartController>();
    final ProductController productController = Get.find<ProductController>();
    final RxInt qty = initialQuantity.obs;

    final hasDesc = !(product.description?.trim().isEmpty ?? true);
    final descText = hasDesc ? product.description!.trim() : 'لا يوجد وصف متاح لهذا المنتج.';

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Get.toNamed(Routes.cart),
          ),
        ],
        title: Text(isFromCart ? 'تعديل الكمية' : product.name, style: AppTextStyles.subheading),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- واجهة عرض المنتج ---
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
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: AppTextStyles.heading.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${product.price.toStringAsFixed(2)} ر.س',
                    style: AppTextStyles.subheading.copyWith(color: AppColors.success),
                  ),
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
                  backgroundColor: AppColors.primary.withOpacity(0.08),
                  labelStyle: AppTextStyles.body.copyWith(color: AppColors.primary),
                ),
                Chip(
                  label: const Text('شحن سريع'),
                  backgroundColor: AppColors.accent.withOpacity(0.08),
                  labelStyle: AppTextStyles.body.copyWith(color: AppColors.accent),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('الوصف', style: AppTextStyles.subheading),
            const SizedBox(height: 8),
            Text(descText, style: AppTextStyles.body),
            const SizedBox(height: 24),

            // --- واجهة التحكم بالسلة (ديناميكية) ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                      Text('${qty.value}', style: AppTextStyles.subheading),
                      IconButton(
                        onPressed: () => qty.value++,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  )),
                  const Spacer(),
                  if (isFromCart)
                  // زر حفظ التعديلات
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
                  // زر الإضافة للسلة
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
