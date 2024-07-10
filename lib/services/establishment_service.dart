import 'dart:convert';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/establishment.model.dart';
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
}
