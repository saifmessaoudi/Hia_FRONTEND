import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/user.model.dart';
import 'package:hia/services/establishement_service.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class EstablishmentViewModel with ChangeNotifier {
  final EstablishementService _establishmentService = EstablishementService();
  final UserViewModel _userViewModel = UserViewModel();

  String? _address;
  String? get address => _address;

  List<Establishment>? _establishments;
  List<Establishment>? get establishments => _establishments;

  int? _lengthEstablishments;
  int? get lengthEstablishments => _lengthEstablishments;

  double? _distance;
  double? get distance => _distance;

  List<double>? _distances;
  List<double>? get distances => _distances;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String _establishmentsBoxName = 'establishmentsBox';

  EstablishmentViewModel() {
    _userViewModel.initSession();
    _initialize();
  }

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Hive.initFlutter();
      await Hive.openBox<Establishment>(_establishmentsBoxName);

      _establishments = await _fetchEstablishmentsFromCache();

      if (_establishments == null || _establishments!.isEmpty) {
        await _fetchEstablishmentsFromService();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error initializing: $e');
    }
  }

  Future<List<Establishment>?> _fetchEstablishmentsFromCache() async {
    try {
      final box = Hive.box<Establishment>(_establishmentsBoxName);
      if (box.isNotEmpty) {
        return box.values.toList();
      }
      return [];
    } catch (e) {
      print('Error fetching from cache: $e');
      return null;
    }
  }

  Future<void> _fetchEstablishmentsFromService() async {
    try {
      List<Establishment> establishments =
          await _establishmentService.getAllEstablishments();
      _establishments = establishments;
      _lengthEstablishments = establishments.length;
      notifyListeners();
      sortByDistance();
      notifyListeners();

      await _saveEstablishmentsToCache(establishments);
    } catch (e) {
      print('Error fetching establishments: $e');
    }
  }

  Future<void> _saveEstablishmentsToCache(List<Establishment> establishments) async {
    try {
      final box = Hive.box<Establishment>(_establishmentsBoxName);
      await box.clear(); // Clear existing data (optional)
      await box.addAll(establishments);
    } catch (e) {
      print('Error saving to cache: $e');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Radius of the earth in km

    final lat1Rad = lat1 * pi / 180;
    final lon1Rad = lon1 * pi / 180;
    final lat2Rad = lat2 * pi / 180;
    final lon2Rad = lon2 * pi / 180;

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * asin(sqrt(a));

    return R * c; // Distance in km
  }

  void calculateDistance(int index) {
    if (_userViewModel.userData == null || _establishments == null || _establishments!.isEmpty) {
      print('User data or establishments are null or empty.');
      return;
    }

    User user = _userViewModel.userData!;
    double lat1 = user.latitude.toDouble();
    double lon1 = user.langitude.toDouble();
    double lat2 = _establishments![index].latitude;
    double lon2 = _establishments![index].langitude;
    _distance = _calculateDistance(lat1, lon1, lat2, lon2);
    notifyListeners();
  }

  void sortByDistance() {
    if (_userViewModel.userData == null || _establishments == null) {
      print('User data or establishments are null.');
      return;
    }

    User user = _userViewModel.userData!;
    double userLat = user.latitude.toDouble();
    double userLon = user.langitude.toDouble();

    _distances = _establishments?.map((establishment) {
      return _calculateDistance(userLat, userLon, establishment.latitude, establishment.langitude);
    }).toList();

    _establishments?.sort((a, b) {
      double distanceA = _calculateDistance(userLat, userLon, a.latitude, a.langitude);
      double distanceB = _calculateDistance(userLat, userLon, b.latitude, b.langitude);
      return distanceA.compareTo(distanceB);
    });

    notifyListeners();
  }

  void launchMaps(double latitude, double longitude) async {
    if (_userViewModel.userData == null) {
      print('User data is null.');
      return;
    }

    try {
      final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=${_userViewModel.userData!.latitude.toDouble()},${_userViewModel.userData!.langitude.toDouble()}&destination=$latitude,$longitude');

      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching maps: $e');
    }
  }
}
