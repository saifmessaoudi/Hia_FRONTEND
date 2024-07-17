import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hia/models/user.model.dart';
import 'package:hia/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';  

class UserViewModel with ChangeNotifier {
  final UserService userService = UserService();
  String? _token;
  String? get token => _token;

  String? _userId;
  String? get userId => _userId;

  User? _userData;
  User? get userData => _userData;

  String? _address;
  String? get address => _address;

  

   UserViewModel() {
    // Initialize session on app startup
    initSession();
  }
bool isAuthenticated() {
    return _token != null;
  }
  Future<void> fetchUserById(String userId) async {
    _userData = await userService.getUserById(userId);
    notifyListeners();
  }

  String? getAuthenticatedUserId(){
    return _userId;
  
  }




  Future<bool> login(String email, String password) async {
    try {
      final response = await userService.login(email, password);

      if (response['token'] != null) {
        _token = response['token'];

        // Extract user ID from the token
        final parts = _token!.split('.');
        final payload =
            json.decode(utf8.decode(base64.decode(base64.normalize(parts[1]))));
        _userId = payload['userId'];

        // Save token and user ID to shared preferences
        await _saveSession();
        notifyListeners();
        await fetchUserById(userId!);

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
    await _clearSession();
    _token = null;
    _userId = null;
    _userData = null;
    notifyListeners();
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('userId', _userId!);
    await initSession();
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  // Initialize session from shared preferences
  Future initSession() async {
   
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getString('userId');
    if (_token != null && isAuthenticated()) {
      await fetchUserById(userId!);
    }
    notifyListeners();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this also prompts the
        // user to go to the settings and enable permissions).
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> loginWithFacebook(String token) async {
    try {
      _token = token;

      final parts = _token!.split('.');
      final payload =
          json.decode(utf8.decode(base64.decode(base64.normalize(parts[1]))));
      _userId = payload['userId'];
      await _saveSession();
      notifyListeners();
      await fetchUserById(userId!);

      notifyListeners();
      return true;
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            '  ${placemark.administrativeArea}, ${placemark.country}';
           _address = address ;
           notifyListeners() ;
        return address;
        
      } else {
        return null;
      }
      
    } catch (error) {
      print('Error getting address from coordinates: $error');
      return null;
    }
  }
  List<String> get foodPreference {
    return _userData?.foodPreference ?? [];
  }


}
