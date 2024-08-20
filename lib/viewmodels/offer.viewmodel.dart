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

  Future<void> refreshOffers() async {
    await fetchOffers();
  }

  Future<void> fetchOffers() async {
    isLoading = true;
    notifyListeners();

    try {
      offers = await _service.getCachedData();
      Debugger.green('Fetched offers from cache: ${offers.length}');
      await _service.cacheData(offers);  // Cache the fetched data
      if (await _service.hasInternetConnection()) {
        final fetchedOffers = await _service.fetchOffers();
        offers = fetchedOffers;
        await _service.cacheData(offers);  // Cache the fetched data
      }
      if (offers.isEmpty) {
        Debugger.red('No offer cached data found, fetching from server...');
        offers = await _service.fetchOffers();
        await _service.cacheData(offers);  
      }
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
