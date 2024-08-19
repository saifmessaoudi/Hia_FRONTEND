import 'package:flutter/material.dart';
import 'package:hia/models/reservation.model.dart';
import 'package:hia/services/reservation_service.dart';

class ReservationViewModel extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _reservationCode;
  String? get reservationCode => _reservationCode;

  bool _isLoadingScreenshot = false;
  bool get isLoadingScreenshot => _isLoadingScreenshot;

  Future<void> addReservation(Reservation reservation) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    try {
      _reservationCode = await _reservationService.addReservation(reservation);
      if (_reservationCode == "ERROR") {
        _reservationCode = null;
      }
    } catch (e) {
      _reservationCode = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLoadingScreenshot(bool value) {
    _isLoadingScreenshot = value;
    notifyListeners();
  }
}