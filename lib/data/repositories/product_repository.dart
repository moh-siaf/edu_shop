import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/product_model.dart';
import 'base_product_repository.dart';

class ProductRepository implements BaseProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _productsRef = FirebaseFirestore.instance.collection('products');

  /// 🔹 تنفيذ جلب كل المنتجات من Firestore (لا تغيير هنا)
  @override
  Future<List<ProductModel>> getAllProducts() async {
    // هذا الكود سليم ويستخدم fromDoc بشكل صحيح
    final snapshot = await _productsRef.get();
    return snapshot.docs.map((doc) => ProductModel.fromDoc(doc)).toList();
  }

  /// 🔹 تنفيذ جلب منتج واحد (لا تغيير هنا)
  @override
  Future<ProductModel?> getProductById(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) return null;
    return ProductModel.fromDoc(doc);
  }

  /// 🔹 تنفيذ إضافة منتج جديد إلى Firestore (✅ الإصلاح الأول هنا)
  @override
  Future<String?> addProduct(ProductModel product) async {
    final docRef = await _productsRef.add({
      'name': product.name,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      // --- السطر الوحيد الذي أضفناه ---
      'categoryId': product.categoryId,
    });
    return docRef.id;
  }

  /// 🔹 دالة حذف منتج من Firestore (لا تغيير هنا)
  @override
  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  /// 🔹 تنفيذ تحديث منتج في Firestore (✅ الإصلاح الثاني هنا)
  @override
  Future<void> updateProduct(ProductModel product) async {
    await _productsRef.doc(product.id).update({
      'name': product.name,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'createdAt': product.createdAt,
      // --- السطر الوحيد الذي أضفناه ---
      'categoryId': product.categoryId,
    });
  }
}
