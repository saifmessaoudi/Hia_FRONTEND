import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hia/helpers/debugging_printer.dart';

class ConnectivityManager extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  bool get isConnected => _isConnected;

  ConnectivityManager() {
    startMonitoring();
    checkInitialConnectivity();
  }

  void startMonitoring() {
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      final wasConnected = _isConnected;
      _isConnected = connectivityResult != ConnectivityResult.none;
      Debugger.magenta("Connectivity changed: wasConnected=$wasConnected, isConnected=$_isConnected");
      if (wasConnected != _isConnected) {
        notifyListeners();
      }
    });
  }

  Future<void> checkInitialConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _isConnected = connectivityResult != ConnectivityResult.none;
    Debugger.magenta("Initial connectivity status: $_isConnected");
    notifyListeners();
  }

  Future<bool> checkConnectivityNow() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _isConnected = connectivityResult != ConnectivityResult.none;
    notifyListeners();
    return _isConnected;
  }
}
