import 'package:hia/models/food.model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'cart_item.model.g.dart';

@HiveType(typeId: 4)
class CartItem extends HiveObject {
  @HiveField(0)
  final Food food;

  @HiveField(1)
  int quantity;

  CartItem({required this.food, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      food: Food.fromJson(json['food']),
      quantity: json['quantity'],
    );
  }

  factory CartItem.fromJsonWithoutFood(Map<String, dynamic> json) {
    return CartItem(
      food: Food.fromJsonWithoutEstablishment(json['food']),
      quantity: json['quantity'],
    );
  }



  String getFormattedPrice() {
  final formatter = NumberFormat('#,##0.000', 'en_US');
  return formatter.format(food.price);
  }


  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'quantity': quantity,
    };
  }
}
