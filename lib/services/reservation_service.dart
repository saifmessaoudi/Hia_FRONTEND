import 'dart:convert';
import 'package:hia/models/reservation.model.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  final String baseUrl = 'http://10.0.2.2:3030';

  Future<String> addReservation(Reservation reservation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservation/addReservation'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reservation.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['reservation']['codeReservation'];
    } else {
      return "ERROR";
    }
  }




 
}
