
import '../../features/offers/model/offer_model.dart';

abstract class BaseOfferRepository {
  Future<List<OfferModel>> getAllOffers();
  Future<void> addOffer(OfferModel offer);
  Future<void> updateOffer(OfferModel offer);
  Future<void> deleteOffer(String offerId);
}
