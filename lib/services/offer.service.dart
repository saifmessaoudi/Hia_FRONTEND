import 'dart:convert';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class OfferService {
  final String baseUrl = 'https://hiabackend-production.up.railway.app';
  static const String cacheKey = 'offerCache';
  late Box<Offer> _box;

  OfferService() {
    _initBox();
  }

  Future<void> _initBox() async {
    if (!Hive.isBoxOpen('offerBox')) {
      _box = await Hive.openBox<Offer>('offerBox');
    } else {
      _box = Hive.box<Offer>('offerBox');
    }
  }

  Future<List<Offer>> fetchOffers() async {
    final response = await http.get(Uri.parse('$baseUrl/offer/getAll'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Offer> offers = data.map((e) {
        return Offer.fromJson(e as Map<String, dynamic>);
      }).toList();
      await cacheData(offers);
      Debugger.green('Offers fetched successfully');
      return offers;
    } else {
      throw Exception('Failed to load establishments');
    }
  }

  Future<void> cacheData(List<Offer> data) async {
    await _box.clear();  // Clear old cached data
    await _box.addAll(data);
  }

  Future<List<Offer>> getCachedData() async {
    List<Offer> cachedData = _box.values.toList();
    Debugger.green('Retrieved cached data ');
    return cachedData;
  }

  Future<bool> hasInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('http://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<Offer>> getOffersByEstablishment(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/offer/getByEstablishment/$id'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Offer> offers = data.map((e) {
        return Offer.fromJson(e as Map<String, dynamic>);
      }).toList();
      return offers;
    } else {
      throw Exception('Failed to load offers');
    }
  }
}