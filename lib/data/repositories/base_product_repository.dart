import 'dart:io';
import '../../model/product_model.dart';

/// 🧱 واجهة عامة للتعامل مع المنتجات (CRUD)
abstract class BaseProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<void> addProduct(ProductModel product);
  Future<ProductModel?> getProductById(String id);
  // حذف منتج بالمعرّف
  Future<void> deleteProduct(String id);
  // ✳️ نضيف دالة تعديل المنتج
  Future<void> updateProduct(ProductModel product);

}

/// 🧱 واجهة عامة للتعامل مع رفع الصور (Storage)
abstract class BaseStorageRepository {
  Future<String?> uploadProductImage(File file);
}

