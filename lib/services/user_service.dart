import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/models/user.model.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  final String baseUrl = 'http://192.168.0.65:3030';
  

  Future<bool> verifyEmail(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/verifEmail?email=$email'),
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

  Future<Map<String, dynamic>> signUp(
      String firstName, String lastName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/register'),
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
        return {
          'success': false,
          'Email already used': responseData['message']
        };
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (error) {
      // Handle network errors or any other exceptions here
      Debugger.red('Error: $error');
      return {
        'success': false,
        'message': 'Failed to sign up. Please try again later.'
      };
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

  Future<void> updateUserLocation(
      String id, String address, double longitude, double latitude) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/updatelocation'),
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
        Debugger.green('Location updated successfully');
      } else {
        throw Exception('Failed to update location: ${response.body}');
      }
    } catch (error) {
      Debugger.red('Error updating location: $error');
    }
  }

  Future<bool> updateUserProfile(String id, String? firstName, String? lastName,
      String? email, String? password) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/updateprofile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': id,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        Debugger.green('Profile updated successfully');
        return true;
      } else {
        Debugger.red('Failed to update profile: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      Debugger.red('Error updating profile: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>> forgetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/send-email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {'success': true, 'message': responseData['message']};
      } else {
        final responseData = jsonDecode(response.body);
        return {'success': false, 'message': responseData['message']};
      }
    } catch (error) {
      Debugger.red('Error: $error');
      return {
        'success': false,
        'message': 'Failed to reset password. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> sendPhoneOtp(String phone, String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/send-phone-otp'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {'success': true, 'message': responseData['message']};
      } else {
        final responseData = jsonDecode(response.body);
        return {'success': false, 'message': responseData['message']};
      }
    } catch (error) {
      Debugger.red('Error: $error');
      return {
        'success': false,
        'message': 'Failed to send OTP. Please try again later.'
      };
    }
  }

  Future<User?> getUserById(String id) async {
    final url = '$baseUrl/user/getuserbyid';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': id,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return User.fromJson(jsonResponse);
      } else {
        Debugger.red('Failed to fetch user: ${response.statusCode}');
        throw Exception('Failed to fetch user: ${response.body}');
      }
    } catch (error) {
      Debugger.red('Error fetching user: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> verifyOtpEmail(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/verify-otp-email'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {'success': true, 'message': responseData['message']};
      } else {
        final responseData = jsonDecode(response.body);
        return {'success': false, 'message': responseData['message']};
      }
    } catch (error) {
      Debugger.red('Error: $error');
      return {
        'success': false,
        'message': 'Failed to verify OTP. Please try again later.'
      };
    }
  }



  Future<Map<String, dynamic>> verifyOtpPhone(String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/verify-otp-phone'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {'success': true, 'message': responseData['message']};
      } else {
        final responseData = jsonDecode(response.body);
        return {'success': false, 'message': responseData['message']};
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Failed to verify OTP. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/change-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {'success': true, 'message': responseData['message']};
      } else {
        final responseData = jsonDecode(response.body);
        return {'success': false, 'message': responseData['message']};
      }
    } catch (error) {
      Debugger.red('Error: $error');
      return {
        'success': false,
        'message': 'Failed to reset password. Please try again later.'
      };
    }
  }
  Future<bool> saveUserPreferences(String userId, List<String> preferences) async {
    final url = Uri.parse('$baseUrl/user/chooseFoodPreference');
    final body = jsonEncode({
      'userId': userId,
      'foodPreference': preferences,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        Debugger.red('Failed to save preferences: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      Debugger.red('Error saving preferences: $error');
      return false;
    }
  }

Future<void> addFoodsToFavourites(String idFood, String userId) async {
    final url = Uri.parse('$baseUrl/user/addFoodsToFavourites'); // Adjust the endpoint as needed

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'Idfood': idFood,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Debugger.green('Food added to favorites: ${data['message']}');
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      Debugger.red('Error: ${data['message']}');
    } else if (response.statusCode == 404) {
      final data = jsonDecode(response.body);
      Debugger.red('Error: ${data['message']}');
    } else {
      // Other errors
      Debugger.red('Error: ${response.statusCode}');
    }
  }
  Future<void> removeFoodsFromFavourites(String idFood, String userId) async {
    final url = Uri.parse('$baseUrl/user/removeFoodsFromFavourites'); // Adjust the endpoint as needed

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'Idfood': idFood,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Debugger.green('Food removed from favorites: ${data['message']}');
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      Debugger.red('Error: ${data['message']}');
    } else if (response.statusCode == 404) {
      final data = jsonDecode(response.body);
      Debugger.red('Error: ${data['message']}');
    } else {
      // Other errors
      Debugger.red('Error: ${response.statusCode}');
    }
  }
  Future<bool> verifFoodFavourite(String userId, String foodId) async {
    final url = Uri.parse('$baseUrl/user/verifFoodFavourite');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'iduser': userId,
        'idfood': foodId,
      }),
    );
    if (response.statusCode == 200) {
      return false ;
    } 

    else if ( response.statusCode == 201) {
       return true ; 
    } else {
      throw Exception('Failed to verify food favourite: ${response.statusCode}');
    }
  }
Future<List<Food>> getFavouriteFoodsByUserId(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/getFavouriteProductsByUserID'),
      body: jsonEncode({'iduser': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Food.fromJsonWithoutEstablishment(item)).toList();
    } else {
      throw Exception('Failed to load favourite foods');
    }
  }

Future<Food?> getFoodById(String id) async {
    final url = '$baseUrl/food/getFoodById';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'idFood': id,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return Food.fromJson(jsonResponse);
      } else {
        Debugger.red('Failed to fetch food: ${response.statusCode}');
        throw Exception('Failed to fetch food: ${response.body}');
      }
    } catch (error) {
      Debugger.red('Error fetching food: $error');
      return null;
    }
  }


}
