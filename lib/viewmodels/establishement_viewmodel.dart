import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/models/user.model.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hive/hive.dart';
import 'package:nb_utils/nb_utils.dart';
import '../services/establishement_service.dart';
import 'package:url_launcher/url_launcher.dart';


class EstablishmentViewModel extends ChangeNotifier {
  final EstablishmentService _service = EstablishmentService();
  List<Establishment> establishments = [];
  List<Establishment> recommendedEstablishments = [];
  bool isLoading = false;
  UserViewModel userViewModel;

  EstablishmentViewModel(this.userViewModel) {
     _userViewModel.initSession();
    _initialize();
    fetchEstablishments();
  }

  Future<void> fetchEstablishments() async {
    isLoading = true;
    notifyListeners();

    try {
      Debugger.yellow('Attempting to fetch cached establishments...');
      establishments = (await _service.getCachedData()) as List<Establishment>;
      if (establishments.isEmpty) {
        Debugger.red('No cached data found, fetching from server...');
        establishments = await _service.fetchEstablishments();
      } else {
        Debugger.green('Loaded establishments from cache.');
        // Fetch new data from server and update cache
        List<Establishment> newEstablishments = await _service.fetchEstablishments();
        establishments = mergeEstablishments(establishments, newEstablishments);
        await _service.cacheData(establishments);
      }
      // Filter establishments based on user preferences
      establishments = filterByPreferences(establishments, userViewModel.foodPreference);
    } catch (e) {
      Debugger.red('Error fetching establishments: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Establishment> mergeEstablishments(List<Establishment> cached, List<Establishment> fetched) {
    final Map<String, Establishment> establishmentMap = {for (var e in cached) e.id: e};
    for (var establishment in fetched) {
      establishmentMap[establishment.id] = establishment;
    }
    return establishmentMap.values.toList();
  }

  List<Establishment> filterByPreferences(List<Establishment> establishments, List<String> preferences) {
    return establishments.where((establishment) {
      return establishment.preferences != null && establishment.preferences!.any((pref) => preferences.contains(pref));
    }).toList();
  }

  final UserViewModel _userViewModel = UserViewModel();

  String? _address;
  String? get address => _address;


  int? _lengthEstablishments;
  int? get lengthEstablishments => _lengthEstablishments;

  double? _distance;
  double? get distance => _distance;

  List<Establishment>? _establishments;

  List<double>? _distances;
  List<double>? get distances => _distances;

  bool _isLoading = false;

  final String _establishmentsBoxName = 'establishmentsBox';


  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
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

 void fetchFoodsFromEstablishment(int i) async {
  try {
    // Ensure the index i is within the bounds of the establishments list
    if (i < 0 || i >= establishments!.length) {
      throw RangeError('Index $i is out of bounds for the list of establishments');
    }

    // Assuming establishments is a list of objects that have an 'id' field
    String establishmentId = establishments![i].id; // Ensure this is the correct field

    // Debug prints
    print('Fetching foods for establishment ID: $establishmentId');

    // Fetch foods using the establishment ID
    List<Food> foods = await _service.getProductsByEstablishmentID(establishmentId);
    print('Fetched foods: $foods');
  } catch (error) {
    print('Error fetching foods: $error');
    print('Index i: $i, Type of i: ${i.runtimeType}');
    print('Establishment at index i: ${establishments![i]}, Type: ${establishments![i].runtimeType}');
  }
}






  Future<void> _fetchEstablishmentsFromService() async {
    try {
      List<Establishment> establishments =
          await _service.getAllEstablishments();
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
    double lon1 = user.longitude.toDouble();
    double lat2 = _establishments![index].latitude;
    double lon2 = _establishments![index].longitude;
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
    double userLon = user.longitude.toDouble();

    _distances = _establishments?.map((establishment) {
      return _calculateDistance(userLat, userLon, establishment.latitude, establishment.longitude);
    }).toList();

    _establishments?.sort((a, b) {
      double distanceA = _calculateDistance(userLat, userLon, a.latitude, a.longitude);
      double distanceB = _calculateDistance(userLat, userLon, b.latitude, b.longitude);
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
      final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=${_userViewModel.userData!.latitude.toDouble()},${_userViewModel.userData!.longitude.toDouble()}&destination=$latitude,$longitude');

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
