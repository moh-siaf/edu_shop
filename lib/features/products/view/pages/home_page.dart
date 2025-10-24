// --- في ملف: lib/features/home/view/pages/home_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

// --- Imports ---
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';

import '../../../../core/widgets/gradient_app_bar.dart';
import '../../../../routes/app_routes.dart';
import '../../../categories/viewmodel/category_controller.dart';
import '../../../products/viewmodel/products_controller.dart';
import '../../viewmodel/banner_controller.dart';

// الصفحة تبقى StatelessWidget
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final CategoryController categoryCtrl = Get.find<CategoryController>();
    // إنشاء نسخة من كنترولر البانر مع tag فريد
    final BannerController bannerCtrl = Get.put(BannerController(), tag: 'home_banner');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          buildFlexibleAppBar(
            context: context,
            title: 'Edu Shop',

            actions: [
              IconButton(
                icon: const Icon(Icons.inventory),
                tooltip: 'إضافة 100 منتج (للاختبار)',
                onPressed: () => Get.find<ProductController>().seedNewProducts(),
              ),
              IconButton(
                icon: const Icon(AppIcons.notifications),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(AppIcons.cart),
                onPressed: () => Get.toNamed(Routes.cart),
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
              child: Column(
                children: [
                  const SizedBox(height: AppSizes.smallSpacing),
                  // --- البانر المحدث الذي يستخدم BannerController ---
                  SizedBox(
                    height: AppSizes.bannerHeight - 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      child: PageView.builder(
                        controller: bannerCtrl.pageController,
                        itemCount: bannerCtrl.banners.length,
                        onPageChanged: bannerCtrl.onPageChanged,
                        itemBuilder: (context, i) {
                          return CachedNetworkImage(
                            imageUrl: bannerCtrl.banners[i],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: theme.cardColor),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.itemSpacing),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن منتج...',
                      prefixIcon: const Icon(AppIcons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.cardColor,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sectionSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الأقسام', style: theme.textTheme.titleLarge),
                      Obx(() => Text('${categoryCtrl.categories.length} قسم', style: theme.textTheme.bodySmall)),
                    ],
                  ),
                  const SizedBox(height: AppSizes.itemSpacing),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
            sliver: Obx(() {
              if (categoryCtrl.isLoading.isTrue && categoryCtrl.categories.isEmpty) {
                // استخدام Shimmer داخل SliverGrid
                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSizes.itemSpacing,
                    crossAxisSpacing: AppSizes.itemSpacing,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => const ShimmerCategoryCard(),
                    childCount: 6,
                  ),
                );
              }
              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.itemSpacing,
                  crossAxisSpacing: AppSizes.itemSpacing,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final category = categoryCtrl.categories[index];
                    return InkWell(
                      onTap: () => Get.toNamed(Routes.productList, arguments: category),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(AppSizes.borderRadiusMedium),
                                  topRight: Radius.circular(AppSizes.borderRadiusMedium),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: category.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (context, url) => Container(color: theme.scaffoldBackgroundColor.withOpacity(0.5)),
                                  errorWidget: (context, error, stackTrace) {
                                    return const Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 40));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppSizes.itemSpacing - 4),
                              child: Text(
                                category.name,
                                style: theme.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: categoryCtrl.categories.length,
                ),
              );
            }),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButton: PopupMenuButton<String>(
        offset: const Offset(0, -120),
        itemBuilder: (context) => [
          PopupMenuItem(value: 'add_category', child: Row(children: [Icon(Icons.category_outlined, color: theme.colorScheme.primary), const SizedBox(width: 8), const Text('إضافة قسم')])),
          PopupMenuItem(value: 'add_product', child: Row(children: [Icon(Icons.add_shopping_cart_outlined, color: theme.colorScheme.primary), const SizedBox(width: 8), const Text('إضافة منتج')])),
        ],
        onSelected: (value) {
          if (value == 'add_category') Get.toNamed(Routes.addProduct);
          if (value == 'add_product') Get.toNamed(Routes.addProduct);
        },
        child: FloatingActionButton(
          onPressed: null,
          backgroundColor: theme.colorScheme.error,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 65,
        child: Stack(
          children: [
            BottomAppBar(
              color: theme.cardColor,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavItem(context, icon: AppIcons.home, label: 'الرئيسية', isActive: true),
                _buildNavItem(context, icon: AppIcons.myAds, label: 'إعلاناتي'),
                const SizedBox(width: 40),
                _buildNavItem(context, icon: AppIcons.auctions, label: 'مزايدة'),
                _buildNavItem(context, icon: AppIcons.more, label: 'المزيد'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required String label, bool isActive = false}) {
    final color = isActive ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodySmall?.color;
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ودجت الشيمر لبطاقة القسم
class ShimmerCategoryCard extends StatelessWidget {
  const ShimmerCategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.borderRadiusMedium),
                    topRight: Radius.circular(AppSizes.borderRadiusMedium),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSizes.itemSpacing - 4),
              child: Container(
                height: 16,
                width: 100,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// تم دمج Shimmer القديم في ShimmerCategoryCard
class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
