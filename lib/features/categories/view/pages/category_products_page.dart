import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../model/category_model.dart';
import '../../../products/viewmodel/products_controller.dart';

class CategoryProductsPage extends StatelessWidget {
  const CategoryProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. استقبل القسم الذي تم الضغط عليه من HomePage
    final CategoryModel category = Get.arguments;

    // 2. اعثر على كنترولر المنتجات
    final ProductController productCtrl = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        // 3. اجعل عنوان الصفحة هو اسم القسم
        title: Text(category.name, style: AppTextStyles.subheading),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Obx(() {
        // 4. قم بتصفية قائمة المنتجات الكاملة
        final filteredProducts = productCtrl.products
            .where((product) => product.categoryId == category.id)
            .toList();

        if (productCtrl.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        if (filteredProducts.isEmpty) {
          return Center(
            child: Text(
              'لا توجد منتجات في قسم "${category.name}" حاليًا',
              style: AppTextStyles.body,
            ),
          );
        }

        // 5. اعرض المنتجات المصفاة في GridView
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8, // نسبة العرض إلى الارتفاع لكل بطاقة
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            // هنا تضع تصميم بطاقة المنتج (Product Card) الذي تستخدمه عادةً
            return Card(
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Hero(
                      // استخدم tag فريد لمنتجات هذه الصفحة
                      tag: 'prod_cat_${product.id}',
                      child: Image.network(product.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(product.name, style: AppTextStyles.body, maxLines: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${product.price} ر.س', style: AppTextStyles.subheading.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
