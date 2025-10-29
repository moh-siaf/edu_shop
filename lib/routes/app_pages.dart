import 'package:get/get.dart';
import '../features/admin/binding/category_binding.dart ---.dart';
import '../features/admin/view/Manage_OffersPage/manage_discounts_page.dart';
import '../features/admin/view/Manage_OffersPage/manage_offers_page.dart';
import '../features/admin/view/Manage_OffersPage/offers_dashboard_page.dart';
import '../features/admin/view/Manage_OffersPage/upsert_offer_page.dart';
import '../features/admin/view/admin_dashboard_page.dart';
import '../features/admin/view/manage_categories_page.dart';
import '../features/admin/view/manage_products_page.dart';
import '../features/admin/view/upsert_category_page.dart';
import '../features/auth/view/pages/login_page.dart';
import '../features/auth/view/pages/register_page.dart';
import '../features/auth/view/pages/splash_page.dart';
import '../features/cart/cart_controller/cart_controller.dart';
import '../features/cart/view/cart_page.dart';

import '../features/categories/view/pages/add_category_page.dart';
import '../features/categories/view/pages/category_products_page.dart';
import '../features/offers/view/offers_page.dart';
import '../features/products/binding/product_binding.dart';
import '../features/admin/view/add_product_page.dart';
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


    GetPage(name: Routes.splash, page: () => const SplashPage()),
    GetPage(name: Routes.login, page: () => const LoginPage()),
    GetPage(name: Routes.register, page: () => const RegisterPage()),
    GetPage(name: Routes.offers, page: () => const OffersPage()),

    GetPage(
      name: Routes.adminDashboard,
      page: () => const AdminDashboardPage(), // تأكد من أن اسم الصفحة صحيح
    ),


    GetPage(
      name: Routes.manageProducts,
      page: () => const ManageProductsPage(),
      binding: AddCategoryBinding(),

    ),

    GetPage(
      name: Routes.manageCategories,
      page: () => const ManageCategoriesPage(),
      binding: AddCategoryBinding(),
    ),

    GetPage(
      name: Routes.addCategory,
      page: () => const AddCategoryPage(),
      binding: AddCategoryBinding(),
    ),

    GetPage(
      name: Routes.manageOffers, // اسم المسار
      page: () => const ManageOffersPage(),
      binding: AddCategoryBinding(),

    ),
    GetPage(
      name: Routes.upsertOffer,
      page: () => const UpsertOfferPage(),
      // نستخدم نفس الـ Binding لأنه يحتاج نفس الكنترولر
      binding: AddCategoryBinding(),
    ),
    GetPage(
      name: Routes.manageDiscounts,
      page: () => const ManageDiscountsPage(),
      binding: AddCategoryBinding(),
    ),
    GetPage(
      name: Routes.offersDashboard, // تأكد من إضافة هذا الثابت في ملف app_routes.dart
      page: () => const OffersDashboardPage(),

    ),
  ];
}
