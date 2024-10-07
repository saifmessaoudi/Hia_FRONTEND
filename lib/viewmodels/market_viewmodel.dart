import 'dart:async';
import 'dart:math';

import 'package:hia/models/market.model.dart';
import 'package:hia/models/user.model.dart';
import 'package:hia/services/market_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketViewModel extends ChangeNotifier {
  final MarketService _service = MarketService();
  List<Market> _markets = [];
  List<Market> get markets => _markets;

 List<Market> _marketsByName = [];
  List<Market> get marketsByName => _marketsByName;

   //List<MapMarker> _markers = [];
  //List<MapMarker> get markers => _markers;

  //List<Establishment> recommendedEstablishments = [];
  bool isLoading = false;
  bool isFiltering = false  ; 
  bool _isSorting = false;
  bool _isCalculating = false;
    // ignore: prefer_final_fields
  UserViewModel userViewModel = UserViewModel();
  //final FoodPreferenceProvider _foodPreferenceProvider;
    Timer? _timer;


  String? _address;
  String? get address => _address;

  int? _lengthEstablishments;
  int? get lengthEstablishments => _lengthEstablishments;

    final double _distance = 0.0;


    List<double> _distances = [];
    bool get isCalculating => _isCalculating;
  bool get isSorting => _isSorting;
  double get distance => _distance;
  List<double> get distances => _distances;



  List<Food>? _foodbyestablishment;
  List<Food>? get foodbyestablishment => _foodbyestablishment;

  final bool _isFetchingFoods = false;

  bool get isFetchingFoods => _isFetchingFoods;
  MarketViewModel(this.userViewModel)  {
    
    fetchMarkets();
    sortByDistance() ; 
    //startTimer() ; 
  }
   void startTimer() {
    _timer = Timer.periodic( const Duration(minutes: 30), (timer) {
      // Call your function here every 60 seconds
      refreshMarkets();
    });
  }


  //pull down refresh function
  Future<void> refreshMarkets() async {
  isLoading = true;
  notifyListeners(); // Notify that refresh is in progress

  try {
    _markets = await _service.fetchMarkets();
    await _service.cacheData(_markets);
    notifyListeners();
    await calculateAllDistances();
    await sortByDistance();
    print("////////////////////////////////////////////////////rfetched new list ${_markets.length}///////////////////////////////////////////////////") ; 

    Debugger.green('Refreshing markets...');
  } catch (e) {
    Debugger.red('Error refreshing markets: $e');
  } finally {
    isLoading = false;
    notifyListeners(); // Only notify once at the end
  }
}
 

 Future<void> fetchMarketsByName(String Name) async {
  isFiltering = true;
  notifyListeners();
  try {
    Debugger.yellow('Attempting to fetch  marketsByName...');
    
     final marketsFiltered= await _service.fetchAllMarketsByName(Name);
    
    
    if (marketsFiltered.isEmpty) {
      Debugger.red('No markets cached data found, fetching from server...');
      print('No markets cached data found, fetching from server... ');

      
    }
    else {
      Debugger.green('Fetched markets By name found...');
      _marketsByName = marketsFiltered;
       notifyListeners() ; 
    


    }
    
   

  } catch (e) {
    Debugger.red('Error fetching markets: $e');
    // Handle the error appropriately, show a dialog or snackbar in the UI
  } finally {
    isFiltering = false;
    notifyListeners();
  }
}
  
  

  Future<void> fetchMarkets() async {
  isLoading = true;
  notifyListeners();
  try {
    Debugger.yellow('Attempting to fetch cached markets...');
    
    _markets = await _service.fetchMarkets();
    final cachedmarkets  = await _service.getCachedData() ; 
    
    if (cachedmarkets.isEmpty) {
      Debugger.red('No markets cached data found, fetching from server...');
      print('No markets cached data found, fetching from server... ');

      await _service.cacheData(_markets);
    }
    else {
      Debugger.red('cached Markets found...');
      print('cached Markets found... ');
      _markets = cachedmarkets;
       notifyListeners() ; 
      await _service.cacheData(_markets);


    }
    
    if (_markets.isNotEmpty) {
      await calculateAllDistances();
      await sortByDistance();
    print('Fetch markets function response: $_markets');
    }

  } catch (e) {
    Debugger.red('Error fetching markets: $e');
    // Handle the error appropriately, show a dialog or snackbar in the UI
  } finally {
    isLoading = false;
    notifyListeners();
  }
}

  /* void listenToPreferences(FoodPreferenceProvider foodPreferenceProvider) {
    foodPreferenceProvider.addListener(() {
      updateRecommendedEstablishments();
    });
  }*/

  /*void updateRecommendedEstablishments()async {
    recommendedEstablishments = filterByPreferences(establishments, _userViewModel.foodPreference);

    notifyListeners();
  }*/


 /* List<Establishment> filterByPreferences(List<Establishment> establishments, List<String> preferences) {
  return establishments.where((establishment) {
    return establishment.preferences != null && establishment.preferences!.any((pref) => preferences.contains(pref));
  }).toList();
}*/


 
/*void updateMarkers(List<Establishment> establishments) {
  _markers = establishments.map((establishment) {
    return MapMarker(
      image: establishment.image,
      title: establishment.name,
      address: establishment.address,
      location: latLng.LatLng(
        establishment.latitude,  
        establishment.longitude,
      ),
      rating: establishment.averageRating,
    );
  }).toList();
  notifyListeners();
}*/



 

 double _calculateDistance(double? lat1, double? lon1, double? lat2, double? lon2) {
    const R = 6371.0; // Radius of the earth in km

    final lat1Rad = lat1! * pi / 180;
    final lon1Rad = lon1! * pi / 180;
    final lat2Rad = lat2! * pi / 180;
    final lon2Rad = lon2! * pi / 180;

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * asin(sqrt(a));

    return R * c; // Distance in km
  }

  Future <void> calculateAllDistances() async {
  _isCalculating = true;
  notifyListeners();
  
    
    try {
      User user = userViewModel.userData!;
      double userLat = user.latitude.toDouble();
      double userLon = user.longitude.toDouble();

      // Simulate a delay for distance calculation

      _distances = markets.map((market) {
        return _calculateDistance(userLat, userLon, market.latitude, market.langitude);
      }).toList();
    } catch (e) {
      Debugger.red('Error calculating distances: $e');
    } finally {
      _isCalculating = false;
      notifyListeners();
    }
}

Future<void> sortByDistance() async {
  if (userViewModel.userData == null) {
    return;
  }

  _isSorting = true;
  notifyListeners();

  try {
    User user = userViewModel.userData!;
    double userLat = user.latitude.toDouble();
    double userLon = user.longitude.toDouble();


    _distances = markets.map((market) {
      return _calculateDistance(
          userLat, userLon, market.latitude, market.langitude);
    }).toList();

    markets.sort((a, b) {
      double distanceA =
          _calculateDistance(userLat, userLon, a.latitude, a.langitude);
      double distanceB =
          _calculateDistance(userLat, userLon, b.latitude, b.langitude);
      return distanceA.compareTo(distanceB);
    });
      notifyListeners();

  } catch (e) {
      Debugger.red('Error sorting by distance: $e');
    } finally {
      _isSorting = false;
      notifyListeners();
    }
  }



  void launchMaps(double? latitude, double? longitude) async {
    if (userViewModel.userData == null) {
      return;
    }

    try {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&origin=${userViewModel.userData!.latitude.toDouble()},${userViewModel.userData!.longitude.toDouble()}&destination=$latitude,$longitude');


      final canLaunch = await canLaunchUrl(url);

      if (canLaunch) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Debugger.red('Error launching maps: $e');
    }
  }
}
