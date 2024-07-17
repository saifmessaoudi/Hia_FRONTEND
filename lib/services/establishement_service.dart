import 'dart:convert';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class EstablishmentService {
  final String baseUrl = 'http://10.0.2.2:3030';
  static const String cacheKey = 'establishmentCache';

  Future<List<Establishment>> fetchEstablishments() async {
    final response = await http.get(Uri.parse('$baseUrl/establishement/getAll'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Establishment> establishments = data.map((e) {
        return Establishment.fromJson(e as Map<String, dynamic>);
      }).toList();
      await cacheData(establishments);
      Debugger.green('Establishments fetched successfully');
      return establishments;
    } else {
      throw Exception('Failed to load establishments');
    }
  }

  Future<void> cacheData(List<Establishment> data) async {
    var box = Hive.box('establishmentBox');
    box.put(cacheKey, data.map((e) => e.toJson()).toList());
    Debugger.green('Data cached successfully');
  }

  Future<List<Establishment>> getCachedData() async {
    var box = Hive.box('establishmentBox');
    List<dynamic> cachedData = box.get(cacheKey, defaultValue: []);
    Debugger.green('Retrieved cached data');
    return cachedData.map((e) {
      return Establishment.fromJson(Map<String, dynamic>.from(e as Map)); // Ensure proper type casting
    }).toList();
  }



Future <List<Establishment>> getAllEstablishments() async {
    final url = Uri.parse('$baseUrl/establishement/getAll');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Establishment> establishments = body
            .map((dynamic item) => Establishment.fromJson(item))
            .toList();
        return establishments;
      } else {
        throw Exception('Failed to load establishments');
      }
    } catch (e) {
      print('Error fetching establishments: $e');
      throw Exception('Failed to load establishments');
    }
  }
   Future<List<Food>> getProductsByEstablishmentID(String id) async {
    final url = Uri.parse('$baseUrl/establishement/getProductsByEstablishmentID');

    // Create the request body
    final Map<String, String> body = {
      'id': id,
    };

    // Debug prints
    print('Sending request to $url with body: $body');

    // Make the POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    // Check the response status and parse the JSON
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(response.body);
      print('Response JSON: $responseJson');

      // Ensure the response is a list of maps
      if (responseJson is List<dynamic>) {
        List<Food> foods = responseJson.map((json) {
          if (json is Map<String, dynamic>) {
            return Food.fromJson(json);
          } else {
            throw Exception('Unexpected JSON format');
          }
        }).toList();
        return foods;
      } else {
        throw Exception('Expected a list in response');
      }
    } else {
      print('Failed response: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

 
}
