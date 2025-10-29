// --- في ملف: lib/features/offers/view/pages/offers_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/gradient_app_bar.dart';

import '../../../../routes/app_routes.dart';
import '../../../model/product_model.dart';
import '../viewmodel/offers_controller.dart';


class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // استخدام Get.put لضمان وجود الكنترولر
    final OffersController controller = Get.put(OffersController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        // --- 1. حالة التحميل (Shimmer) ---
        if (controller.isLoading.value) {
          return const OffersPageShimmer();
        }
        // --- 2. حالة الخطأ ---
        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey),
                const SizedBox(height: AppSizes.itemSpacing),
                Text('فشل تحميل البيانات', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSizes.smallSpacing),
                Text('يرجى التحقق من اتصالك بالإنترنت', style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSizes.sectionSpacing),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchAllOffersData(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        // --- 3. حالة عدم وجود أي عروض أو منتجات مخفضة ---
        if (controller.generalOffers.isEmpty && controller.discountedProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(AppIcons.offers, size: 80, color: Colors.grey),
                const SizedBox(height: AppSizes.itemSpacing),
                Text('لا توجد عروض حاليًا', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSizes.smallSpacing),
                Text('ترقب عروضنا القادمة!', style: theme.textTheme.bodyMedium),
              ],
            ),
          );
        }

        // --- 4. عرض البيانات (الحالة الطبيعية) ---
        return CustomScrollView(
          slivers: [
            buildFlexibleAppBar(
              context: context,
              title: 'العروض والتخفيضات',
              actions: [
                IconButton(
                  icon: const Icon(AppIcons.cart),
                  onPressed: () => Get.toNamed(Routes.cart),
                ),
              ],
            ),
            // --- عرض بانرات العروض العامة ---
            if (controller.generalOffers.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildGeneralOffersSection(context, controller),
              ),

            // --- عنوان قسم المنتجات المخفضة ---
            if (controller.discountedProducts.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildSectionTitle(context, 'أقوى الخصومات', AppIcons.bestSelling),
              ),

            // --- قائمة المنتجات المخفضة ---
            SliverPadding(
              padding: const EdgeInsets.all(AppSizes.pagePadding),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.itemSpacing,
                  crossAxisSpacing: AppSizes.itemSpacing,
                  childAspectRatio: 0.65, // تعديل النسبة لتناسب عرض السعرين
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = controller.discountedProducts[index];
                    return _buildDiscountedProductCard(context, product);
                  },
                  childCount: controller.discountedProducts.length,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- دوال مساعدة لبناء أجزاء الواجهة ---

  Widget _buildGeneralOffersSection(BuildContext context, OffersController controller) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'عروضنا المميزة', AppIcons.exclusive),
        SizedBox(
          height: AppSizes.bannerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.generalOffers.length,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
            itemBuilder: (context, index) {
              final offer = controller.generalOffers[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.only(left: AppSizes.itemSpacing),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: offer.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (c, u, e) => const Icon(Icons.error),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(offer.title, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                            Text(offer.description, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountedProductCard(BuildContext context, ProductModel product) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.productDetails, arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSizes.borderRadiusMedium),
                    topRight: Radius.circular(AppSizes.borderRadiusMedium),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (c, u) => Container(color: theme.scaffoldBackgroundColor),
                    errorWidget: (c, u, e) => const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
                // --- شارة الخصم ---
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                    ),
                    child: Text(
                      '${product.discountPercentage}%',
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.itemSpacing - 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // --- عرض السعرين ---
                    Text(
                      '${product.price.toStringAsFixed(2)} ر.س',
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough, // خط في المنتصف
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${product.discountPrice?.toStringAsFixed(2)} ر.س',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        ],
      ),
    );
  }
}

// --- ودجت الـ Shimmer لصفحة العروض ---
class OffersPageShimmer extends StatelessWidget {
  const OffersPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          buildFlexibleAppBar(context: context, title: 'العروض والتخفيضات'),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shimmer للعنوان
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Container(height: 24, width: 150, color: Colors.black),
                ),
                // Shimmer للبانرات
                SizedBox(
                  height: AppSizes.bannerHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) => Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: const EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      ),
                    ),
                  ),
                ),
                // Shimmer للعنوان الثاني
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Container(height: 24, width: 200, color: Colors.black),
                ),
              ],
            ),
          ),
          // Shimmer لشبكة المنتجات
          SliverPadding(
            padding: const EdgeInsets.all(AppSizes.pagePadding),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.itemSpacing,
                crossAxisSpacing: AppSizes.itemSpacing,
                childAspectRatio: 0.65,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                  ),
                ),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
