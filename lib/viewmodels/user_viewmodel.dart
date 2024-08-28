import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/food.model.dart';
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  
   bool _isFavourite = false;  
    bool get isFavourite => _isFavourite;

 List<Food>? _favouriteFood ;
  List<Food>? get favouritefood => _favouriteFood;

  Food? _foodById ;
  Food? get foodById => _foodById;

  String? _emailError;
  String? get emailError => _emailError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  bool _hasError = false;
  bool get hasError => _hasError;



 final Map<String, bool> _favouritesMap = {}; // Map to track favorite status

  bool getFavouriteStatus(String foodId) {
    return _favouritesMap[foodId] ?? false;
  }

  
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




  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
     _emailError = email.isEmpty
        ? 'Please enter your email'
        : !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                .hasMatch(email)
            ? 'Please enter a valid email'
            : null;
    _passwordError = password.isEmpty
        ? 'Please enter your password'
        : password.length < 6
            ? 'Password must be at least 6 characters long'
            : null;
    if (_emailError == null && _passwordError == null) {
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

      } else {
         _emailError = response['message'] == 'Invalid email'
            ? 'Invalid email'
            : null;
        _passwordError = response['message'] == 'Invalid password'
            ? 'Invalid password'
            : null;
      }
    }

    _isLoading = false;
    notifyListeners();
    
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
      Debugger.red('Error: $error');
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
      Debugger.red('Error getting address from coordinates: $error');
      return null;
    }
  }
  List<String> get foodPreference {
    return _userData?.foodPreference ?? [];
  }

  Future<void> fetchUpdatedUserData() async {
    if (_userId != null) {
      _userData = await userService.getUserById(_userId!);
      notifyListeners();
    }
  }
   Future<void> verifFoodFavourite(String foodId, String userId) async {
     try {
      await getFoodById(foodId);
      bool isFavourite = await userService.verifFoodFavourite(userId, foodId);
      _favouritesMap[foodId] = isFavourite; 
      notifyListeners();
    } catch (e) {
      _favouritesMap[foodId] = false;
      notifyListeners();
    }
  }

  

Future<void> addFoodsToFavourites(String idFood, String userId) async {
  _favouritesMap[idFood] = true;
  notifyListeners();
  try {
    // Ensure the food is fetched before adding to favourites
    await getFoodById(idFood);

    // Add food to the user's favourites
    await userService.addFoodsToFavourites(idFood, userId);

    // Check if the food is already in the favourites list
    bool isAlreadyFavourite = _favouriteFood?.any((food) => food.id == idFood) ?? false;

    // Add food to the favourites list if it's not already there
    if (!isAlreadyFavourite && foodById != null) {
      _favouriteFood?.add(foodById!);
      notifyListeners();
    }

  } catch (e) {
    Debugger.red('Error adding to favourites: $e');
  }
}


  Future<void> removeFoodsFromFavourites(String idFood, String userId) async {
   _favouritesMap[idFood] = false;
      notifyListeners(); 
      try {
           await getFoodById(idFood); 

      await userService.removeFoodsFromFavourites(idFood, userId);
        // Check if the food is already in the favourites list
    bool isAlreadyFavourite = _favouriteFood?.any((food) => food.id == idFood) ?? false;

    // Add food to the favourites list if it's not already there
    if (isAlreadyFavourite && foodById != null) {
      _favouriteFood!.remove(foodById!); 
      notifyListeners() ; 
    }

      
    } catch (e) {
      Debugger.red('Error removing from favourites: $e');
    }
  }

  Future<void> getFavouriteFood(String userId) async {
      _isLoading = true;
      _hasError = false;
      notifyListeners();
      try {
        _favouriteFood = await userService.getFavouriteFoodsByUserId(userId);
        for (var food in _favouriteFood!) {
          _favouritesMap[food.id] = true;
        }
      } catch (e) {
        Debugger.red('Failed to load favourite foods: $e');
        _hasError = true;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

   Future<void> getFoodById(String foodid) async {
    try {
      _foodById = await userService.getFoodById(foodid);
      notifyListeners();
    } catch (e) {
      Debugger.red('Failed to load getFoodById: $e');
    }
  }

  void toggleFavorite() {
    _isFavourite = !_isFavourite;
    notifyListeners();
  }

  void setFavorite(bool value) {
    _isFavourite = value;
    notifyListeners();
  }
}
