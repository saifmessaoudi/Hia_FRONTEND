import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/market.model.dart';
import 'package:hia/models/product.model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class MarketService {
  final String baseUrl = 'http://192.168.0.65:3030';
  static const String cacheKey = 'marketCache';

  Future<List<Market>> fetchMarkets() async {
    final response = await http.get(Uri.parse('$baseUrl/market/getAllMarkets'));
   


    if (response.statusCode == 200) {

      List<dynamic> data = json.decode(response.body);
      List<Market> markets = data.map((e) {
        return Market.fromJson(e as Map<String, dynamic>);
      }).toList();
print(markets) ; 
      await cacheData(markets);
      Debugger.green('markets fetched successfully');
      print('markets fetched successfully');
print('Fetch markets function response 2 : ${response.body}');

      return markets;
    } else {
        print('Failed to load markets');

      throw Exception('Failed to load markets');

    }
  }

  Future<List<Market>> fetchAllMarketsByName(String name) async {
    final url = Uri.parse('$baseUrl/market/fetchAllMarketsByName');

    // Create the request body
    final Map<String, String> body = {
      'name': name,
    };

    // Debug prints
    Debugger.red('Sending request to $url with body: $body');

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
      Debugger.red('Response JSON: $responseJson');

      List<Market> Markets = responseJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Market.fromJson(json);
        } else {
          throw Exception('Unexpected JSON format');
        }
      }).toList();
      return Markets;
        } else {
      Debugger.red('Failed response: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  Future<void> cacheData(List<Market> data) async {
    var box = Hive.box<Market>('marketsBox');
     await box.clear();
     await box.addAll(data);
    Debugger.green('Markets cached successfully');
          print('markets fetched successfully cacheData ');

    

  }



  Future<List<Market>> getCachedData() async {
    var box = Hive.box<Market>('marketsBox');
    List<Market> cachedData = box.values.toList();
    Debugger.green('Retrieved cached markets data');
print('Fetch cachedData function : $cachedData');

    return  cachedData;
   
  }


//hasInternetConnection() method
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }


Future <List<Market>> getAllMarkets() async {
    final url = Uri.parse('$baseUrl/market/getAllMarkets');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Market> markets = body
            .map((dynamic item) => Market.fromJson(item))
            .toList();
        return markets;
      } else {
        throw Exception('Failed to load markets');
      }
    } catch (e) {
      Debugger.red('Error fetching markets: $e');
      throw Exception('Failed to load markets');
    }
  }
    Future<List<Product>> getProductsByEstablishmentID(String id) async {
    final url = Uri.parse('$baseUrl/market/getProductsByMarketID');

    // Create the request body
    final Map<String, String> body = {
      'id': id,
    };

    // Debug prints
    Debugger.red('Sending request to $url with body: $body');

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
      Debugger.red('Response JSON: $responseJson');

      List<Product> products= responseJson.map((json) {
        if (json is Map<String, dynamic>) {
          return Product.fromJson(json);
        } else {
          throw Exception('Unexpected JSON format');
        }
      }).toList();
      return products;
        } else {
      Debugger.red('Failed response: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

 
}
