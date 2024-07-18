import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:nb_utils/nb_utils.dart';

class ConnectivityManager extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  ConnectivityManager() {
    startMonitoring();
    // Optionally, you can remove checkInitialConnectivity() if you prefer to only rely on monitoring.
    // checkInitialConnectivity();
  }

  void startMonitoring() {
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      final wasConnected = _isConnected;
      _isConnected = connectivityResult != ConnectivityResult.wifi ||
          connectivityResult != ConnectivityResult.mobile;
      if (wasConnected != _isConnected) {
        notifyListeners();
        if (!_isConnected) {
          toast('No internet connection');
        }
      }
    });
  }
}
