import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/services/offer.service.dart';
import 'dart:async';

class OfferViewModel extends ChangeNotifier {
  final OfferService service = OfferService();
  List<Offer> _offers = [];
  final Map<String, DateTime> _endTimes = {};
  Timer? _globalTimer;
  final Queue<String> _deletionQueue = Queue<String>();
  bool _isProcessing = false;
  Timer? _batchTimer;
  static const _batchDelay = Duration(milliseconds: 300);

  List<Offer> get offers => List.unmodifiable(_offers);

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
      _offers = await service.getCachedData();
      Debugger.green('Fetched offers from cache: ${offers.length}');
      await service.cacheData(offers);  // Cache the fetched data
      bool internetAvailable = await _retryInternetCheck(retries: 3, delay: const Duration(seconds: 2));
      if (internetAvailable) {
        final fetchedOffers = await service.fetchOffers();
        _offers = fetchedOffers;
        await service.cacheData(offers);  // Cache the fetched data
      }else if (offers.isEmpty) {
        Debugger.red('No offer cached data found, fetching from server...');
        _offers = await service.fetchOffers();
        await service.cacheData(offers);  
      }
    } catch (e) {
      Debugger.red('Error fetching offers: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _retryInternetCheck({ int retries=3,  Duration delay=const Duration(seconds: 2)}) async {
    for (var i = 0; i < retries; i++) {
     if (await service.hasInternetConnection()) {
        return true;
      }
      await Future.delayed(delay);
    }
    return false;
  }

  List<Offer> mergeOffers(List<Offer> cached, List<Offer> fetched) {
    final Map<String, Offer> offerMap = {for (var e in cached) e.name: e};
    for (var offer in fetched) {
      offerMap[offer.name] = offer;
    }
    return offerMap.values.toList();
  }

  List<Offer> getOffersByEstablishment(String id) {
    return _offers.where((offer) => offer.etablishment.id == id).toList();
  }
   Future<void> deleteOffer(String offerId) async {
    try {

      _offers.removeWhere((offer) => offer.id == offerId);
        notifyListeners();
       await service.deleteOfferById(offerId) ; 

        
     
    } catch (e) {
      print('Error deleting offer: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    _batchTimer?.cancel();
    super.dispose();
  }

  void initializeTimers(List<Offer> offers) {
    _offers = offers;
    
    // Initialize end times map
    for (var offer in offers) {
      _endTimes[offer.id] = offer.validUntil; // Changed endTime to expirationTime
    }

    // Start global timer
    _startGlobalTimer();
    notifyListeners();
  }

  void _startGlobalTimer() {
    _globalTimer?.cancel();
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      bool needsUpdate = false;

      // Check all active offers
      _endTimes.forEach((offerId, endTime) {
        if (endTime.isBefore(now)) {
          _deletionQueue.add(offerId);
          _endTimes.remove(offerId);
          needsUpdate = true;
        }
      });

      if (needsUpdate) {
        _processExpiredOffers();
      }
    });
  }

  void _processExpiredOffers() {
    if (_deletionQueue.isEmpty) return;

    // Remove expired offers from local state
    _offers = _offers.where((offer) => !_deletionQueue.contains(offer.id)).toList();
    notifyListeners();

    // Process backend deletions
    if (!_isProcessing) {
      _isProcessing = true;
      _processBatchDeletion();
    }
  }

  Future<void> _processBatchDeletion() async {
    try {
      while (_deletionQueue.isNotEmpty) {
        final batch = <String>[];
        while (batch.length < 5 && _deletionQueue.isNotEmpty) {
          batch.add(_deletionQueue.removeFirst());
        }

        await Future.wait(
          batch.map((id) => service.deleteOfferById(id).catchError((error) {
            if (!error.toString().contains('404')) {
              debugPrint('Error deleting offer $id: $error');
            }
            return null;
          })),
        );
      }
    } finally {
      _isProcessing = false;
    }
  }

  Duration? getRemainingTime(String offerId) {
    final endTime = _endTimes[offerId];
    if (endTime == null) return null;
    
    final remaining = endTime.difference(DateTime.now());
    return remaining.isNegative ? null : remaining;
  }

  Future<void> removeOfferLocally(String offerId) async {
    if (_deletionQueue.contains(offerId)) return;
    
    _deletionQueue.add(offerId);
    
    // Create new list and force rebuild
    _offers = List.from(_offers)..removeWhere((offer) => offer.id == offerId);
    
    // Notify twice to ensure complete rebuild
    notifyListeners();
    Future.microtask(notifyListeners);

    _batchTimer?.cancel();
    _batchTimer = Timer(_batchDelay, () {
      if (!_isProcessing) {
        _isProcessing = true;
        _processBatchDeletion();
      }
    });
  }
}
