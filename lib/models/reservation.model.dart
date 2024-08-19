import 'package:hia/models/cart/cart_item.model.dart';
import 'package:hia/models/establishement.model.dart';

class Reservation {
  final String userId;
  final String? etablishmentId;
  final List<CartItem> items;
  final String? codeReservation;
  final String? id;
  final DateTime? date;
  final Establishment? establishment;
  final String? status;
  final int? totalPrice;

  Reservation({
    required this.userId,
    this.etablishmentId,
    required this.items,
    this.codeReservation,
    this.id,
    this.date,
    this.establishment,
    this.status,
    this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'etablishmentId': etablishmentId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      userId: json['user'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJsonWithoutFood(item))
          .toList(),
      codeReservation: json['codeReservation'],
      id: json['_id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      establishment: json['etablishment'] != null &&
              json['etablishment'] is Map<String, dynamic>
          ? Establishment.fromJsonWithoutFoods(json['etablishment'])
          : null,
      status: json['status'],
      totalPrice: json['totalPrice'],
    );
  }
}
