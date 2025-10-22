import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../categories/viewmodel/category_controller.dart';
import '../../viewmodel/products_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryCtrl = Get.find<CategoryController>();


    final RxInt bannerIndex = 0.obs;
    final List<String> banners = [
      'https://via.placeholder.com/600x250.png?text=Offer+1',
      'https://via.placeholder.com/600x250.png?text=New+Arrivals',
      'https://via.placeholder.com/600x250.png?text=Sale+50%25',
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // الانتقال إلى صفحة إضافة المنتج
          Get.toNamed(Routes.addProduct);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // 💡 الإصلاح: إضافة لون خلفية للصفحة لتجنب السواد الكامل عند حدوث خطأ
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // 1. الشريط العلوي (لا تغيير هنا )
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.primary,
            title: const Text('متجرنا الفاخر', style: AppTextStyles.subheading),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Get.toNamed(Routes.cart),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن منتج...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // 2. السلايدر (لا تغيير هنا، كان صحيحًا)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180,
              child: PageView.builder(
                itemCount: banners.length,
                onPageChanged: (i) => bannerIndex.value = i,
                controller: PageController(viewportFraction: 0.9),
                itemBuilder: (context, i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(banners[i]),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 3. عنوان "الأقسام" (لا تغيير هنا)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('الأقسام', style: AppTextStyles.subheading),
            ),
          ),

          // 4. قائمة الأقسام - 💡 الإصلاح الرئيسي هنا
          // يجب أن يكون Obx يلف الويدجت الذي يعتمد على البيانات مباشرة
          Obx(() {
            if (categoryCtrl.isLoading.isTrue && categoryCtrl.categories.isEmpty) {
              // اعرض التحميل فقط إذا كانت القائمة فارغة
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (categoryCtrl.categories.isEmpty) {
              // اعرض رسالة إذا كانت القائمة فارغة بعد انتهاء التحميل
              return const SliverFillRemaining(
                  child: Center(child: Text('لا توجد أقسام متاحة حاليًا'))
              );
            }

            // إذا كانت هناك بيانات، قم ببناء الشبكة
            return SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final category = categoryCtrl.categories[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed(Routes.productList, arguments: category);
                      },

                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        child: Hero(
                          tag: 'category_${category.id}',
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(category.imageUrl, fit: BoxFit.cover),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Text(
                                  category.name,
                                  style: AppTextStyles.subheading.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: categoryCtrl.categories.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
