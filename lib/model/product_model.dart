import 'package:cloud_firestore/cloud_firestore.dart';

/// 🧱 نموذج بيانات المنتج (بسيط وواقعي)
/// ملاحظات مهمة:
/// - نحفظ id = نفس معرف الوثيقة في Firestore.
/// - نخلي الحقول الأساسية فقط: الاسم، السعر، الصورة، الوصف.
/// - createdAt اختياري ونحوّله بين DateTime و Timestamp تلقائيًا.
class ProductModel {
  final String id;            // معرف المنتج = documentId في Firestore
  final String name;          // اسم المنتج
  final double price;         // السعر
  final String imageUrl;      // رابط صورة المنتج (من Storage أو أي URL)
  final String? description;  // وصف مختصر (اختياري)
  final DateTime? createdAt;  // تاريخ الإنشاء (اختياري)

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
    this.createdAt,
  });

  /// ✅ التحويل من خريطة (map) قادمة من Firestore إلى كائن Dart
  /// - docId يأتينا من DocumentSnapshot.id (خارج البيانات)
  factory ProductModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};

    // price قد يأتي int أو double من Firestore؛ نحوله Double بشكل آمن
    final rawPrice = data['price'];
    final doublePrice = rawPrice is int ? rawPrice.toDouble() : (rawPrice as double? ?? 0.0);

    // createdAt قد يكون Timestamp؛ نحوّله إلى DateTime
    final ts = data['createdAt'];
    final created = ts is Timestamp ? ts.toDate() : (ts is DateTime ? ts : null);

    return ProductModel(
      id: doc.id,
      name: (data['name'] as String? ?? '').trim(),
      price: doublePrice,
      imageUrl: (data['imageUrl'] as String? ?? '').trim(),
      description: (data['description'] as String?)?.trim(),
      createdAt: created,
    );
  }

  /// ✅ التحويل إلى خريطة (map) لحفظها في Firestore
  /// - نستخدم Timestamp.fromDate لـ createdAt إذا كانت موجودة
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      if (description != null && description!.isNotEmpty) 'description': description,
      if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  /// نسخ مع تعديل (مفيد لاحقًا للتحديثات)
  ProductModel copyWith({
    String? name,
    double? price,
    String? imageUrl,
    String? description,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
