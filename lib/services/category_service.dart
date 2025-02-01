import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/category.model.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = 'http://10.0.2.2:3030';
  static const String cacheKey = 'CategoryCache';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category/fetchCategories'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Category> categories = data.map((e) {
        return Category.fromJson(e as Map<String, dynamic>);
      }).toList();
     
      await cacheData(categories);
      Debugger.green('Establishments fetched successfully');
      return categories;
    } else {
      throw Exception('Failed to load establishments');
    }
  }

  Future<void> cacheData(List<Category> data) async {
    var box = Hive.box<Category>('CategoriesBox');
     await box.clear();
     await box.addAll(data);
    Debugger.green('Categories cached successfully');

  }
  Future<List<Category>> getCachedData() async {
    var box = Hive.box<Category>('CategoriesBox');
    List<Category> cachedData = box.values.toList();
    Debugger.green('Retrieved cached Categories data');
    return  cachedData;
   
  }


//hasInternetConnection() method
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }



 
}
