import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {

  final String baseUrl = 'http://192.168.1.19:3030';


Future<bool> verifyEmail(String email) async {
  final response = await http.get(
    Uri.parse(baseUrl + '/user/verifEmail?email=$email'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    return responseData['success'];
  } else {
    throw Exception('Failed to verify email');
  }
}


Future<Map<String, dynamic>> signUp(String firstName, String lastName, String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl + '/user/register'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {'success': true, 'message': responseData['message']};
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body);
      return {'success': false, 'Email already used': responseData['message']};
    } else {
      throw Exception('Failed to sign up');
    }
  } catch (error) {
    // Handle network errors or any other exceptions here
    print('Error: $error');
    return {'success': false, 'message': 'Failed to sign up. Please try again later.'};
  }
}



Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final responseData = jsonDecode(response.body);
      return {'success': false, 'message': responseData['message']};
    }
  }

   Future<void> updateUserLocation(String id, String address, double longitude, double latitude) async {
    try {
      final response = await http.put(
      Uri.parse(baseUrl + '/user/updatelocation'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': id,
          'address': address,
          'langitude': longitude,
          'latitude': latitude,
        }),
      );

      if (response.statusCode == 200) {
        print('Location updated successfully');
      } else {
        throw Exception('Failed to update location: ${response.body}');
      }
    } catch (error) {
      print('Error updating location: $error');
      throw error;
    }
  }



}
