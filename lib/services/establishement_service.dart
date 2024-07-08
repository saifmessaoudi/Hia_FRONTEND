import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hia/models/establishement.model.dart';

import 'package:http/http.dart' as http;

class EstablishementService extends ChangeNotifier {
  final String baseUrl = 'http://10.0.2.2:3030';

Future<List<Establishment>> getAllEstablishments() async {
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
 
}
