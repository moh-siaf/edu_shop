import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../model/category_model.dart';
import '../../../products/viewmodel/products_controller.dart';

class CategoryProductsPage extends StatelessWidget {
  const CategoryProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryModel category = Get.arguments;
    final ProductController productCtrl = Get.find<ProductController>();
    final filteredProducts = productCtrl.products.where((p) => p.categoryId == category.id).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- 1. الهيدر المتفاعل (SliverAppBar) ---
          SliverAppBar(
            expandedHeight: 200.0, // ارتفاع الهيدر عند التوسيع
            floating: true, // يظهر بمجرد السحب للأسفل
            pinned: true, // يبقى شريط العنوان الصغير ظاهرًا دائمًا
            snap: true, // يكمل الظهور أو الاختفاء تلقائيًا
            flexibleSpace: FlexibleSpaceBar(
              title: Text(category.name, style: const TextStyle(shadows: [Shadow(blurRadius: 8)])),
              background: Image.network(
                category.imageUrl, // صورة القسم كخلفية للهيدر
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.4), // لتغميق الخلفية وإبراز النص
                colorBlendMode: BlendMode.darken,
              ),
              centerTitle: true,
            ),
          ),

          // --- 2. بانر الإعلانات (سيتم برمجته لاحقًا) ---
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/600x200/B2EBF2/000000?Text=Special+Offer' ), // صورة إعلان مؤقتة
                  fit: BoxFit.cover,
                ),
              ),
              // TODO: برمجة نظام الإعلانات هنا لاحقًا
            ),
          ),

          // --- 3. قسم "الأكثر مبيعًا" (قائمة أفقية) ---
          _buildHorizontalSection(
            title: 'الأكثر مبيعًا 🔥',
            products: filteredProducts, // TODO: يجب جلب المنتجات الأكثر مبيعًا فعليًا
          ),

          // --- 4. قسم "الأعلى تقييمًا" (قائمة أفقية) ---
          _buildHorizontalSection(
            title: 'الأعلى تقييمًا ⭐',
            products: filteredProducts.reversed.toList(), // TODO: يجب جلب الأعلى تقييمًا فعليًا
          ),

          // --- 5. عنوان لشبكة المنتجات الرئيسية ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('كل المنتجات', style: Theme.of(context).textTheme.titleLarge),
            ),
          ),

          // --- 6. شبكة المنتجات الرئيسية ---
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final product = filteredProducts[index];
                  // استخدام بطاقة المنتج مع تأثير اللمس
                  return _buildProductCard(product);
                },
                childCount: filteredProducts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ويدجت منفصل لبطاقة المنتج مع تأثير اللمس ---
  Widget _buildProductCard(product) {
    return Card(
      clipBehavior: Clip.antiAlias, // لضمان تطبيق انحناء الحواف على الصورة
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: الانتقال لصفحة تفاصيل المنتج
          print('Pressed on ${product.name}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 8),
              child: Text('${product.price} ر.س', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  // --- ويدجت منفصل للأقسام الأفقية ---
  SliverToBoxAdapter _buildHorizontalSection({required String title, required List products}) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(title, style: Get.theme.textTheme.titleLarge),
          ),
          SizedBox(
            height: 220, // ارتفاع القائمة الأفقية
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 150, // عرض كل عنصر في القائمة الأفقية
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildProductCard(products[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
