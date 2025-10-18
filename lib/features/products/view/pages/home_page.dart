import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

import '../../../../routes/app_routes.dart';
import '../../viewmodel/products_controller.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    final RxInt bannerIndex = 0.obs;
    final List<String> banners = [
      'https://i.ibb.co/g4ykLwS/banner1.jpg',
      'https://i.ibb.co/VJ3jV2s/banner2.jpg',
      'https://i.ibb.co/syC7M6b/banner3.jpg',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = controller.products;
        if (products.isEmpty) {
          return const Center(child: Text('لا توجد منتجات حالياً'));
        }

        return CustomScrollView(
          slivers: [
            // 🔹 الشريط العلوي
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: AppColors.primary,
              title: const Text('المتجر الفاخر', style: AppTextStyles.subheading),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),

            // 🔸 السلايدر (بدون مكتبة خارجية)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: 160,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        itemCount: banners.length,
                        onPageChanged: (i) => bannerIndex.value = i,
                        controller: PageController(viewportFraction: 0.9),
                        itemBuilder: (context, i) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                banners[i],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported, size: 50),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // 🔸 المؤشرات (النقاط)
                      Positioned(
                        bottom: 8,
                        child: Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(banners.length, (i) {
                              final isActive = i == bannerIndex.value;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: isActive ? 18 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.white : Colors.white60,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 قسم حصرياً لك
            SliverToBoxAdapter(
              child: _buildSectionTitle('حصرياً لك'),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: products.length.clamp(0, 6),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ExclusiveCard(product: product);
                  },
                ),
              ),
            ),

            // 🔹 قسم الأكثر مبيعاً
            SliverToBoxAdapter(
              child: _buildSectionTitle('الأكثر مبيعاً'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = products[index];
                    return _ProductCard(product: product);
                  },
                  childCount: products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.subheading.copyWith(color: AppColors.primary)),
          Text('عرض الكل', style: AppTextStyles.body.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }
}

// 🧱 كرت قسم "حصرياً لك"
class _ExclusiveCard extends StatelessWidget {
  final dynamic product;
  const _ExclusiveCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product_${product.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTextStyles.body),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(2)} ر.س',
                    style: AppTextStyles.subheading.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🧱 كرت المنتج في الشبكة
class _ProductCard extends StatelessWidget {
  final dynamic product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
      child: Hero(
        tag: 'product_${product.id}',
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.subheading),
                    const SizedBox(height: 4),
                    Text(
                      '${product.price} ر.س',
                      style: AppTextStyles.body.copyWith(color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
