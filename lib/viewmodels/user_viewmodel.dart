import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hia/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel with ChangeNotifier {
  final UserService userService = UserService();
  String? _token;
  String? get token => _token;

  String? _userId;
  String? get userId => _userId;

  Future<bool> login(String email, String password) async {
    try {
      final response = await userService.login(email, password);

      if (response['token'] != null) {
        _token = response['token'];

        // Extract user ID from the token
        final parts = _token!.split('.');
        final payload = json.decode(utf8.decode(base64.decode(base64.normalize(parts[1]))));
        _userId = payload['userId'];
         print(_userId) ;
        // Save token and user ID to shared preferences
        await _saveSession();
        

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<void> logout() async {
    // Clear token and user ID from shared preferences
    await _clearSession();
    _token = null;
    _userId = null;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('userId', _userId!);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  // Initialize session from shared preferences
  Future<void> initSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getString('userId');
    notifyListeners();
  }
}
