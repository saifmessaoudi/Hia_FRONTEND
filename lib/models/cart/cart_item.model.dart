import 'package:hia/models/food.model.dart';
import 'package:hive/hive.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'food': food.toJson(),
      'quantity': quantity,
    };
  }
}
