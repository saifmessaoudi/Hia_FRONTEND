import 'dart:convert';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class OfferService {
  final String baseUrl = 'http://192.168.155.145:3030';
  static const String cacheKey = 'offerCache';

  Future<List<Offer>> fetchOffers() async {
    final response = await http.get(Uri.parse('$baseUrl/offer/getAll'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Offer> offers = data.map((e) {
        return Offer.fromJson(e as Map<String, dynamic>);
      }).toList();
      await cacheData(offers);
      Debugger.green('Establishments fetched successfully');
      return offers;
    } else {
      throw Exception('Failed to load establishments');
    }
  }

  Future<void> cacheData(List<Offer> data) async {
    var box = Hive.box('offerBox');
    box.put(cacheKey, data.map((e) => e.toJson()).toList());
    Debugger.green('Data cached successfully');
  }

  Future<List<Offer>> getCachedData() async {
    var box = Hive.box('offerBox');
    List<dynamic> cachedData = box.get(cacheKey, defaultValue: []);
    Debugger.green('Retrieved cached data');
    return cachedData.map((e) {
      return Offer.fromJson(Map<String, dynamic>.from(e as Map)); // Ensure proper type casting
    }).toList();
  }

  Future<bool> hasInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('http://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
