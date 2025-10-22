import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String? description;
  final DateTime? createdAt;
  final String categoryId;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
    this.createdAt,
    required this.categoryId,
  });

  // --- دالة القراءة من Firestore (تبقى كما هي) ---
  factory ProductModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    final rawPrice = data['price'];
    final doublePrice = rawPrice is int ? rawPrice.toDouble() : (rawPrice as double? ?? 0.0);
    final ts = data['createdAt'];
    final created = ts is Timestamp ? ts.toDate() : (ts is DateTime ? ts : null);

    return ProductModel(
      id: doc.id,
      name: (data['name'] as String? ?? '').trim(),
      price: doublePrice,
      imageUrl: (data['imageUrl'] as String? ?? '').trim(),
      description: (data['description'] as String?)?.trim(),
      createdAt: created,
      categoryId: (data['categoryId'] as String? ?? '').trim(),
    );
  }

  // --- 1. تعديل toMap لتكون متوافقة مع الحفظ المحلي ---
  Map<String, dynamic> toMap() {
    return {
      'id': id, // مهم جدًا لحفظ الـ ID
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'categoryId': categoryId,
      // تحويل التاريخ إلى نص (ISO 8601) ليكون قابلًا للتخزين في GetStorage
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // --- 2. إضافة fromMap للقراءة من الذاكرة المحلية ---
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'] as String,
      description: map['description'] as String?,
      categoryId: map['categoryId'] as String,
      // قراءة التاريخ كنص ثم تحويله مرة أخرى إلى DateTime
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  // دالة toFirestoreMap (للكتابة في Firestore فقط)
  Map<String, dynamic> toFirestoreMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      if (description != null && description!.isNotEmpty) 'description': description,
      // استخدام Timestamp عند الكتابة في Firestore
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  // دالة copyWith (تبقى كما هي)
  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    String? description,
    DateTime? createdAt,
    String? categoryId,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
