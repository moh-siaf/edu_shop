import 'package:get/get.dart';
import '../features/products/view/pages/product_list_page.dart';
import '../features/products/view/pages/add_product_page.dart';
import '../features/products/binding/product_binding.dart';

class AppPages {
  static const initial = Routes.products;

  static final routes = [
    GetPage(
      name: Routes.products,
      page: () => const ProductListPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.addProduct,
      page: () => AddProductPage(),
      binding: ProductBinding(),
    ),
  ];
}

class Routes {
  static const products = '/products';
  static const addProduct = '/add-product';
}
