import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class FoodService {
  final String baseUrl = 'http://192.168.152.145:3030';
  static const String cacheKey = 'foodCache';

  Future<List<Food>> fetchFoods() async {
    final response = await http.get(Uri.parse('$baseUrl/food/getAllFoods'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Food> foods = data.map((e) {
        return Food.fromJson(e as Map<String, dynamic>);
      }).toList();
      await cacheData(foods);
      return foods;
    } else {
      throw Exception('Failed to load foods');
    }
  }
 
    Future<void> cacheData(List<Food> foods) async {
    var box = await Hive.openBox('foodBox');
    await box.clear();  // Clear old cached data
    for (var food in foods) {
      await box.add(food);
    }
  }

   Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<Food>> getCachedData() async {
    var box = Hive.box('foodBox');
    List<dynamic> cachedData = box.get(FoodService.cacheKey, defaultValue: []);
    Debugger.green('Retrieved cached data');
    return cachedData.map((e) {
      return Food.fromJson(Map<String, dynamic>.from(e as Map)); // Ensure proper type casting
    }).toList();
  }
 

  



}
