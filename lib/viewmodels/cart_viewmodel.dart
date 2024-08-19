import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/cart/cart.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hive/hive.dart';

class CartViewModel extends ChangeNotifier {
  late Box<Cart> _cartBox;
  Cart? _cart;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  Cart? get cart => _cart;

  int get cartLength => _cart?.items.length ?? 0;



  CartViewModel() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _cartBox = await Hive.openBox<Cart>('cartBox');
    _cart = _cartBox.get('cart', defaultValue: Cart(items: []));
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addItem(Food food, int quantity)async {
    try {
      bool result = await _cart?.addItem(food, quantity) ?? false;
      return result;
    }catch (e){
      Debugger.red('Error adding item to cart: $e');
      return false;
    }
  }
  
 void removeItem(Food food) {
    _cart?.removeItem(food);
    notifyListeners();
 }

 //update the quantity of the item
  void updateItemQuantity(Food food, int quantity) {
    _cart?.updateItemQuantity(food, quantity);
    notifyListeners();
  }

  double getTotalPrice() {
    return _cart?.getTotalPrice() ?? 0.0;
  }
}
