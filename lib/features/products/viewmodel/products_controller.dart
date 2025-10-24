// --- في ملف: lib/features/products/viewmodel/products_controller.dart ---

import 'package:get/get.dart';
import 'dart:io';

import '../../../data/repositories/base_product_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../model/product_model.dart';


class ProductController extends GetxController {
  final BaseProductRepository _repo = ProductRepository();
  final BaseStorageRepository _storageRepo = StorageRepository();

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final data = await _repo.getAllProducts();
      products.assignAll(data);
    } catch (e) {
      print("Product fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  ProductModel? getById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _repo.addProduct(product);
    fetchProducts();
  }

  Future<String?> pickAndUploadImage(File file) async {
    final url = await _storageRepo.uploadProductImage(file);
    return url;
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _repo.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _repo.updateProduct(product);
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
        products.refresh();
      }
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product');
    }
  }
}
