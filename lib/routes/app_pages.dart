import 'package:get/get.dart';
import '../features/cart/cart_controller/cart_controller.dart';
import '../features/cart/view/cart_page.dart';
import '../features/categories/view/pages/category_products_page.dart';
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

    ),
    GetPage(
      name: Routes.addProduct,
      page: () => const AddProductPage(),


    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailsPage(),


    ),
// في AppPages.dart أو routes file
    GetPage(
      name: Routes.cart,
      page: () => const CartPage(),

    ),

    GetPage(
      name: Routes.CATEGORY_PRODUCTS,
      page: () => const CategoryProductsPage(),


    ),

  ];
}
