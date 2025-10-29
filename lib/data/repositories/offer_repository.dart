// --- في ملف: lib/data/repositories/offer/offer_repository.dart ---
// (النسخة المعدلة لتتوافق مع المودل)

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/offers/model/offer_model.dart';
import 'base_offer_repository.dart';

class OfferRepository extends BaseOfferRepository {
  final FirebaseFirestore _firestore;

  OfferRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String _collectionName = 'offers';

  @override
  Future<void> addOffer(OfferModel offer) async {
    try {
      // ✅ تم التعديل: استخدام toFirestoreMap()
      await _firestore.collection(_collectionName).add(offer.toFirestoreMap());
    } catch (e) {
      throw Exception('فشل إضافة العرض: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteOffer(String offerId) async {
    try {
      await _firestore.collection(_collectionName).doc(offerId).delete();
    } catch (e) {
      throw Exception('فشل حذف العرض: ${e.toString()}');
    }
  }

  @override
  Future<List<OfferModel>> getAllOffers() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      // ✅ تم التعديل: استخدام fromDoc()
      return snapshot.docs.map((doc) => OfferModel.fromDoc(doc)).toList();
    } catch (e) {
      throw Exception('فشل جلب العروض: ${e.toString()}');
    }
  }

  @override
  Future<void> updateOffer(OfferModel offer) async {
    try {
      // ✅ تم التعديل: استخدام toFirestoreMap()
      await _firestore
          .collection(_collectionName)
          .doc(offer.id)
          .update(offer.toFirestoreMap());
    } catch (e) {
      throw Exception('فشل تحديث العرض: ${e.toString()}');
    }
  }
}
