import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/category_model.dart';
import 'BaseCategoryRepository.dart';


class CategoryRepository implements BaseCategoryRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) => CategoryModel.fromDoc(doc)).toList();
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    await _firestore.collection('categories').add(category.toMap());
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _firestore
        .collection('categories')
        .doc(category.id)
        .update(category.toMap());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _firestore.collection('categories').doc(id).delete();
  }
}
