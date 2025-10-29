// --- في ملف: lib/model/offer_model.dart ---

import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  // ✅ 1. تمت إضافة حقل النوع
  final String type; // 'banner' أو 'product_discount'

  final int discountPercentage;
  final String? productId;

  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type, // ✅ 2. تمت إضافته هنا
    required this.discountPercentage,
    this.productId,
  });

  factory OfferModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return OfferModel(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      // ✅ 3. تمت إضافته هنا (مع قيمة افتراضية للعروض القديمة)
      type: data['type'] as String? ?? 'banner',
      discountPercentage: data['discountPercentage'] as int? ?? 0,
      productId: data['productId'] as String?,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type, // ✅ 4. تمت إضافته هنا
      'discountPercentage': discountPercentage,
      if (productId != null) 'productId': productId,
    };
  }

  OfferModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? type, // ✅ 5. تمت إضافته هنا
    int? discountPercentage,
    String? productId,
  }) {
    return OfferModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type, // ✅ 6. تمت إضافته هنا
      discountPercentage: discountPercentage ?? this.discountPercentage,
      productId: productId ?? this.productId,
    );
  }

  const OfferModel.empty()
      : id = '',
        title = '',
        description = '',
        imageUrl = '',
        type = '', // ✅ 7. تمت إضافته هنا
        discountPercentage = 0,
        productId = null;
}
