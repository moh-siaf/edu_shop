import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/category_model.dart';
import 'BaseCategoryRepository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _firebaseFirestore.collection('categories').get();
      return snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    try {
      // أضف القسم كمستند جديد. Firestore سيقوم بإنشاء ID فريد له.
      await _firebaseFirestore.collection('categories').add(category.toMap());
    } catch (e) {
      print("Error adding category: $e");
      // يمكنك هنا إطلاق exception مخصص إذا أردت
    }
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    try {
      // اذهب إلى المستند المحدد بالـ ID وقم بتحديث بياناته
      await _firebaseFirestore
          .collection('categories')
          .doc(category.id)
          .update(category.toMap());
    } catch (e) {
      print("Error updating category: $e");
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      // اذهب إلى المستند المحدد بالـ ID وقم بحذفه
      await _firebaseFirestore.collection('categories').doc(categoryId).delete();
    } catch (e) {
      print("Error deleting category: $e");
    }
  }
}
