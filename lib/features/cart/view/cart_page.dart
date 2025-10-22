import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routes/app_routes.dart';
import '../../products/viewmodel/products_controller.dart';
import '../cart_controller/cart_controller.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق', style: AppTextStyles.subheading),
        centerTitle: true,
      ),
      // استخدام Obx لمراقبة التغييرات في السلة
      body: Obx(() {
        // في حالة كانت السلة فارغة، اعرض رسالة لطيفة
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text('سلتك فارغة بعد!', style: AppTextStyles.subheading),
                Text('أضف بعض المنتجات الرائعة', style: AppTextStyles.body),
              ],
            ),
          );
        }

        // إذا كانت هناك منتجات، اعرضها في قائمة
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final cartItem = cartController.cartItems[index];
            final product = cartItem.product;

            // استخدام Dismissible للحذف عند السحب
            return Dismissible(
              key: Key(product.id), // مفتاح فريد لكل عنصر
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
                  color: AppColors.error.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete_sweep_outlined, color: Colors.white, size: 30),
              ),
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        // صورة المنتج
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

                        // التفاصيل (الاسم والسعر)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.price.toStringAsFixed(2)} ر.س',
                                style: AppTextStyles.body.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),

                        // *** التعديل الرئيسي هنا ***
                        // عرض الكمية فقط، بدون أزرار
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'x ${cartItem.quantity}', // عرض الكمية بشكل أنيق
                            style: AppTextStyles.subheading.copyWith(color: AppColors.textPrimary),
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
      // الشريط السفلي لعرض الإجمالي (يبقى كما هو)
      bottomNavigationBar: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
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
                  const Text('الإجمالي:', style: AppTextStyles.body),
                  Text(
                    '${cartController.totalPrice.toStringAsFixed(2)} ر.س',
                    style: AppTextStyles.heading.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () { /* لاحقًا لصفحة الدفع */ },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  textStyle: AppTextStyles.button,
                ),
                child: const Text('إتمام الشراء'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
