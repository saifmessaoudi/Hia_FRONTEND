import 'package:hia/models/cart/cart_item.model.dart';

class Reservation {
  final String userId;
  final String etablishmentId;
  final List<CartItem> items;

  Reservation({
    required this.userId,
    required this.etablishmentId,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'etablishmentId': etablishmentId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
