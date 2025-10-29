// --- في ملف: lib/features/products/view/pages/product_list_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

// --- Imports ---
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/gradient_app_bar.dart';

import '../../../../model/category_model.dart';
import '../../../../model/product_model.dart';
import '../../../../routes/app_routes.dart';
import '../../viewmodel/banner_controller.dart';
import '../../viewmodel/products_controller.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ProductController productCtrl = Get.find<ProductController>();
    final BannerController bannerCtrl = Get.find<BannerController>();
    final CategoryModel? category = Get.arguments as CategoryModel?;
    final bool isFiltered = category != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        final List<ProductModel> displayProducts = isFiltered
            ? productCtrl.products.where((p) => p.categoryId == category!.id).toList()
            : productCtrl.products;

        return CustomScrollView(
          slivers: [
            buildFlexibleAppBar(
              context: context,
              title: isFiltered ? category!.name : 'قائمة المنتجات',
              actions: [
                IconButton(
                  icon: const Icon(AppIcons.cart),
                  onPressed: () => Get.toNamed(Routes.cart),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: AppSizes.bannerHeight,
                    margin: const EdgeInsets.all(AppSizes.pagePadding),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      child: PageView.builder(
                        controller: bannerCtrl.pageController,
                        itemCount: bannerCtrl.banners.length,
                        onPageChanged: bannerCtrl.onPageChanged,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: bannerCtrl.banners[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: theme.cardColor),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                  ),
                  if (displayProducts.isNotEmpty) ...[
                    _buildHorizontalSection(
                      context: context,
                      title: 'حصرياً لك',
                      icon: AppIcons.exclusive,
                      products: displayProducts.take(5).toList(),
                    ),
                    _buildHorizontalSection(
                      context: context,
                      title: 'الأكثر مبيعاً',
                      icon: AppIcons.bestSelling,
                      products: displayProducts.skip(5).take(5).toList(),
                    ),
                  ],
                  _buildSectionTitle(context, 'كل المنتجات', AppIcons.allProducts),
                ],
              ),
            ),
            if (productCtrl.isLoading.value && displayProducts.isEmpty)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            else if (displayProducts.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    isFiltered ? 'لا توجد منتجات في هذا القسم حاليًا' : 'لا توجد منتجات حالياً',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = displayProducts[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(AppSizes.pagePadding, 0, AppSizes.pagePadding, AppSizes.itemSpacing - 4),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
                        child: Hero(
                          tag: 'product_list_${product.id}',
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(AppSizes.borderRadiusMedium),
                                        bottomRight: Radius.circular(AppSizes.borderRadiusMedium),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: product.imageUrl,
                                        height: 110,
                                        width: 110,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
                                        errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40),
                                      ),
                                    ),
                                    if (product.discountPercentage > 0)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.error,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${product.discountPercentage}%',
                                            style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: AppSizes.itemSpacing - 4),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.name, style: theme.textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        if (product.discountPercentage <= 0)
                                          Text(
                                            '${product.price.toStringAsFixed(2)} ر.س',
                                            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                                          )
                                        else
                                        // --- ✅ [مُعدل]: استخدام FittedBox لحل الـ Overflow ---
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${product.discountPrice?.toStringAsFixed(2)} ر.س',
                                                  style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${product.price.toStringAsFixed(2)} ر.س',
                                                  style: theme.textTheme.bodySmall?.copyWith(
                                                    color: Colors.grey,
                                                    decoration: TextDecoration.lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: displayProducts.length,
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () => Get.toNamed(Routes.addProduct),
        child: const Icon(AppIcons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.pagePadding, AppSizes.sectionSpacing,
        AppSizes.pagePadding, AppSizes.itemSpacing,
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: AppSizes.iconSizeMedium),
          const SizedBox(width: AppSizes.smallSpacing),
          Text(title, style: theme.textTheme.titleLarge),
          const Spacer(),
          Text('عرض الكل', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary)),
        ],
      ),
    );
  }

  Widget _buildHorizontalSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<ProductModel> products,
  }) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, title, icon),
        SizedBox(
          height: AppSizes.horizontalListHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildHorizontalProductCard(context, product);
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildHorizontalProductCard(BuildContext context, ProductModel product) {
  final theme = Theme.of(context);
  return GestureDetector(
    onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
    child: Container(
      width: AppSizes.pagePadding * 10,
      margin: const EdgeInsets.only(left: AppSizes.itemSpacing),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: theme.cardColor),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            if (product.discountPercentage > 0)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${product.discountPercentage}%',
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppSizes.itemSpacing,
              right: AppSizes.itemSpacing,
              left: AppSizes.itemSpacing,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (product.discountPercentage <= 0)
                    Text(
                      '${product.price.toStringAsFixed(2)} ر.س',
                      style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                    )
                  else
                  // --- ✅ [مُعدل]: استخدام FittedBox هنا أيضًا ---
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${product.discountPrice?.toStringAsFixed(2)} ر.س',
                            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${product.price.toStringAsFixed(2)} ر.س',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white70,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
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
