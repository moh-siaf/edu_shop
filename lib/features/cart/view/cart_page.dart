// --- في ملف: lib/features/cart/view/pages/cart_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../model/product_model.dart';
import '../../../../routes/app_routes.dart';
import '../cart_controller/cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- ✅ جلب الثيم الحالي ---
    final theme = Theme.of(context);
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      // --- ✅ استخدام لون الخلفية من الثيم ---
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // AppBar سيأخذ لونه من الثيم تلقائيًا
        title: const Text('سلة التسوق'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ استخدام لون النص الثانوي من الثيم
                Icon(Icons.shopping_cart_outlined, size: 80, color: theme.textTheme.bodySmall?.color),
                const SizedBox(height: 16),
                // ✅ استخدام ستايلات النصوص من الثيم
                Text('سلتك فارغة بعد!', style: theme.textTheme.titleLarge),
                Text('أضف بعض المنتجات الرائعة', style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final cartItem = cartController.cartItems[index];
            final product = cartItem.product;

            return Dismissible(
              key: Key(product.id),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {
                cartController.removeFromCart(product.id);
                Get.snackbar(
                  'تم الحذف',
                  'تم حذف "${product.name}" من السلة',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              background: Container(
                decoration: BoxDecoration(
                  // ✅ استخدام لون الخطأ من الثيم
                  color: theme.colorScheme.error.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete_sweep_outlined, color: Colors.white, size: 30),
              ),
              child: Card(
                // Card سيأخذ ستايله من الثيم تلقائيًا
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Get.toNamed(
                      Routes.productDetails,
                      arguments: {
                        'product': product,
                        'quantity': cartItem.quantity,
                        'source': 'cart',
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ استخدام ستايل ولون النص من الثيم
                              Text(
                                product.name,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // ✅ استخدام لون النص الأساسي من الثيم
                              Text(
                                '${product.price.toStringAsFixed(2)} ر.س',
                                style: AppTextStyles.body.copyWith(color: theme.colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            // ✅ استخدام لون الخلفية من الثيم
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'x ${cartItem.quantity}',
                            // ✅ استخدام ستايل ولون النص من الثيم
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ استخدام ستايل ولون النص من الثيم
                  Text('الإجمالي:', style: theme.textTheme.bodyMedium),
                  // ✅ استخدام لون النص الأساسي من الثيم
                  Text(
                    '${cartController.totalPrice.toStringAsFixed(2)} ر.س',
                    style: theme.textTheme.displaySmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                ],
              ),
              // ElevatedButton سيأخذ ستايله من الثيم تلقائيًا
              ElevatedButton(
                onPressed: () { /* لاحقًا لصفحة الدفع */ },
                child: const Text('إتمام الشراء'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
