import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/food.model.dart';

import 'package:http/http.dart' as http;

class EstablishementService extends ChangeNotifier {
  final String baseUrl = 'http://192.168.30.145:3030';

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
