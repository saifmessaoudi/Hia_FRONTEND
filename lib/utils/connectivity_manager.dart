import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/widgets/custom_toast.dart';

class ConnectivityManager extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  ConnectivityManager() {
    startMonitoring();
    checkInitialConnectivity();
  }

  void startMonitoring() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
      bool previouslyConnected = _isConnected;
      _isConnected = connectivityResult != ConnectivityResult.none;

      // Only notify if the connection status has changed
      if (previouslyConnected != _isConnected) {
        Debugger.red("Connectivity Result: $connectivityResult");
        Debugger.green("Is Connected: $_isConnected");
        notifyListeners();
      }
    });
  }

  Future<void> checkInitialConnectivity() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    bool wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;

    // Notify only if the initial connectivity status differs from the current status
    if (wasConnected != _isConnected) {
      Debugger.red("Initial Connectivity Result: $result");
      Debugger.green("Initial Is Connected: $_isConnected");
      notifyListeners();
    }


  }
}
