import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/cart/cart_item.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hive/hive.dart';

part 'cart.model.g.dart';

@HiveType(typeId: 5)
class Cart extends HiveObject {
  @HiveField(0)
  List<CartItem> items;

  Cart({required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

 void addItem(Food food, int quantity) {
  Debugger.blue('Adding item: ${food.name}, quantity: $quantity');

  // Find the index of the existing item
  int existingIndex = items.indexWhere((item) => item.food.id == food.id);

  if (existingIndex != -1) {
    // Update the quantity of the existing item
    items[existingIndex].quantity += quantity;
    Debugger.blue('Updated existing item quantity: ${items[existingIndex].quantity}');
  } else {
    // Add the new item to the cart
    items.add(CartItem(food: food, quantity: quantity));
    Debugger.blue('Added new item: ${food.name}, quantity: $quantity');
  }

  save(); // Save the updated cart
}




  void removeItem(Food food) {
    items.removeWhere((item) => item.food.id == food.id);
    save();
  }

  void updateItemQuantity(Food food, int quantity) {
    int existingIndex = items.indexWhere((item) => item.food.id == food.id);

    if (existingIndex != -1) {
      if (quantity == 0) {
        items.removeAt(existingIndex);
      } else {
        items[existingIndex].quantity = quantity;
      }
      save();
    }

  }

 

  double getTotalPrice() {
    return items.fold(0, (total, item) => total + (item.food.price * item.quantity));
  }
}