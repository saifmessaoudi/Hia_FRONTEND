import 'dart:math';
import 'package:hia/viewmodels/market_viewmodel.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/models/map_marker.dart';
import 'package:hia/models/user.model.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/foodPreference/food_pref_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import '../services/establishement_service.dart';
import 'package:url_launcher/url_launcher.dart';

class EstablishmentViewModel extends ChangeNotifier {
  final EstablishmentService _service = EstablishmentService();
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  


  
}
