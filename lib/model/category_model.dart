// --- في ملف: lib/model/category_model.dart ---

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // دالة لتحويل بيانات القسم إلى Map لحفظها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  // دالة لإنشاء كائن CategoryModel من مستند Firestore
  factory CategoryModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return CategoryModel(
      id: snap.id, // نأخذ الـ ID من المستند نفسه
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // ✅✅✅ الدالة الجديدة التي أضفناها ✅✅✅
  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
