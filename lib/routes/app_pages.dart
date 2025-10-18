import 'package:get/get.dart';
import '../features/products/binding/product_binding.dart';
import '../features/products/view/pages/add_product_page.dart';
import '../features/products/view/pages/home_page.dart';
import '../features/products/view/pages/product_details_page.dart';
import '../features/products/view/pages/product_list_page.dart';

import '../features/products/viewmodel/products_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
  // 🏠 الصفحة الرئيسية الجديدة
  GetPage(
  name: Routes.home,
  page: () => const HomePage(),
    binding: ProductBinding(),
  ),

    GetPage(
      name: Routes.productList,
      page: () => const ProductListPage(),
  binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.addProduct,
      page: () => const AddProductPage(),
      binding: ProductBinding(),

    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailsPage(),
     binding: ProductBinding(),

    ),

  ];
}
