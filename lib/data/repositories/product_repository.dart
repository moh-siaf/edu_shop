import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/product_model.dart';
import 'base_product_repository.dart';

class ProductRepository implements BaseProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _productsRef = FirebaseFirestore.instance.collection('products');

  /// 🔹 تنفيذ جلب كل المنتجات من Firestore
  @override
  Future<List<ProductModel>> getAllProducts() async {
    final snapshot = await _productsRef.get();
    return snapshot.docs.map((doc) => ProductModel.fromDoc(doc)).toList();
  }

  /// 🔹 تنفيذ جلب منتج واحد من Firestore
  @override
  Future<ProductModel?> getProductById(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) return null;
    return ProductModel.fromDoc(doc);
  }

  /// 🔹 تنفيذ إضافة منتج جديد إلى Firestore
  @override
  Future<String?> addProduct(ProductModel product) async {
    final docRef = await _productsRef.add({
      'name': product.name,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }
  // 🔹 دالة حذف منتج من Firestore


  @override
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }
  @override
  Future<void> updateProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.id).update({
      'name': product.name,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'createdAt': product.createdAt,
    });
  }


}
