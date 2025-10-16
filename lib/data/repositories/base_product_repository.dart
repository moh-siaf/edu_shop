import 'dart:io';
import '../../model/product_model.dart';

/// 🧱 واجهة عامة للتعامل مع المنتجات (CRUD)
abstract class BaseProductRepository {
  Future<List<ProductModel>> getAllProducts();
  Future<void> addProduct(ProductModel product);
  Future<ProductModel?> getProductById(String id);
}

/// 🧱 واجهة عامة للتعامل مع رفع الصور (Storage)
abstract class BaseStorageRepository {
  Future<String?> uploadProductImage(File file);
}
