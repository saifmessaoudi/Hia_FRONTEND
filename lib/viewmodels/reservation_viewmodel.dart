import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/reservation.model.dart';
import 'package:hia/services/reservation_service.dart';

class ReservationViewModel extends ChangeNotifier {
  final ReservationService _reservationService = ReservationService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _reservationCode;
  String? get reservationCode => _reservationCode;

   List<Reservation> _reservations = [];

  List<Reservation> get myReservation => _reservations;

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

  Future<void> getMyReservations(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      Debugger.green("fetching reservations for user $userId");
      _reservations = await _reservationService.getReservationsByUserId("666b0adf641d4360d56e326a");
    } catch (e) {
      _reservations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}