import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
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

  int? _lengthestablishments;
  int? get lengthestablishments => _lengthestablishments;

  double? _distance;
  double? get distance => _distance;

  List<double>? _distances;
  List<double>? get distances => _distances;
   bool _isLoading = false;
  bool get isLoading => _isLoading;

  EstablishmentViewModel() {
    _fetchEstablishments();
  }

  Future<void> _fetchEstablishments() async {
    _isLoading = true;
    notifyListeners();
    try {
      List<Establishment> establishments = await _establishmentService.getAllEstablishments();
      _establishments = establishments;
      notifyListeners();
      _lengthestablishments = establishments.length;
      notifyListeners();
      sortByDistance();
      _isLoading = false;
      notifyListeners();
      print(_establishments);
    } catch (e) {
      _isLoading = false;
      
      print('Error fetching establishments: $e');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; 
    final lat1Rad = lat1 * pi / 180;
    final lon1Rad = lon1 * pi / 180;
    final lat2Rad = lat2 * pi / 180;
    final lon2Rad = lon2 * pi / 180;

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
              cos(lat1Rad) * cos(lat2Rad) *
              sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * asin(sqrt(a));

    return R * c;
  }

  void calculateDistance(int index) {
    User user = _userViewModel.userData!;
    double lat1 = user.latitude.toDouble();
    double lon1 = user.langitude.toDouble();
    double lat2 = _establishments![index].latitude;
    double lon2 = _establishments![index].langitude;
    _distance = _calculateDistance(lat1, lon1, lat2, lon2);
    notifyListeners();
  }

  void sortByDistance() {
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
    final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=${_userViewModel.userData!.latitude.toDouble()},${_userViewModel.userData!.langitude.toDouble()}&destination=$latitude,$longitude');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}