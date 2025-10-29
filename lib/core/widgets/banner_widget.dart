// --- في ملف: lib/core/widgets/banner_widget.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../features/products/viewmodel/banner_controller.dart';
import '../constants/app_sizes.dart';


/// ودجت قابل لإعادة الاستخدام لعرض بانر إعلانات متحرك.
class BannerWidget extends StatelessWidget {
  /// هل يجب عرض مؤشر النقاط أسفل البانر.
  final bool showIndicator;
  final double? height;

  const BannerWidget({
    super.key,
    this.showIndicator = true, // القيمة الافتراضية هي true
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final BannerController controller = Get.put(BannerController());

    if (controller.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      // استخدام الارتفاع المخصص أو الارتفاع الافتراضي
      height: height ?? AppSizes.bannerHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // --- عارض الصور ---
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.banners.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              final bannerUrl = controller.banners[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                child: CachedNetworkImage(
                  imageUrl: bannerUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: theme.scaffoldBackgroundColor),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image_outlined)),
                ),
              );
            },
          ),

          // --- ✅ عرض مؤشر النقاط بشكل مشروط ✅ ---
          if (showIndicator)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.smallSpacing),
              child: Obx(
                    () => SmoothPageIndicator(
                  controller: controller.pageController,
                  count: controller.banners.length,
                  onDotClicked: (index) => controller.pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  ),
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: theme.colorScheme.primary,
                    dotColor: Colors.grey.withOpacity(0.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
