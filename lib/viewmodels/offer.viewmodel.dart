import 'package:flutter/foundation.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/services/offer.service.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';


class OfferViewModel extends ChangeNotifier {
final OfferService _service = OfferService();
  List<Offer> offers = [];
  bool isLoading = false;

  OfferViewModel() {
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    isLoading = true;
    notifyListeners();

    try {
      offers = await _service.fetchOffers();
      Debugger.green('Offers fetched successfully');
    } catch (e) {
      Debugger.red('Error fetching offers: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Offer> mergeOffers(List<Offer> cached, List<Offer> fetched) {
    final Map<String, Offer> offerMap = {for (var e in cached) e.name: e};
    for (var offer in fetched) {
      offerMap[offer.name] = offer;
    }
    return offerMap.values.toList();
  }

  List<Offer> getOffersByEstablishment(String id) {
    return offers.where((offer) => offer.etablishment.id == id).toList();
  }

 }
