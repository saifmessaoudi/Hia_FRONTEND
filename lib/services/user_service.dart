import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hia/models/user.model.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  final String baseUrl = 'http://192.168.242.145:3030';

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
        return {
          'success': false,
          'Email already used': responseData['message']
        };
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (error) {
      // Handle network errors or any other exceptions here
      print('Error: $error');
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
        print('Profile updated successfully');
        return true;
      } else {
        print('Failed to update profile: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error updating profile: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>> forgetPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + '/user/send-email'),
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
      print('Error: $error');
      return {
        'success': false,
        'message': 'Failed to reset password. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> sendPhoneOtp(String phone, String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + '/user/send-phone-otp'),
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
      print('Error: $error');
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
        print('Failed to fetch user: ${response.statusCode}');
        throw Exception('Failed to fetch user: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>> verifyOtpEmail(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + '/user/verify-otp-email'),
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
      print('Error: $error');
      return {
        'success': false,
        'message': 'Failed to verify OTP. Please try again later.'
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtpPhone(String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + '/user/verify-otp-phone'),
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
        Uri.parse(baseUrl + '/user/change-password'),
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
      print('Error: $error');
      return {
        'success': false,
        'message': 'Failed to reset password. Please try again later.'
      };
    }
  }
}
