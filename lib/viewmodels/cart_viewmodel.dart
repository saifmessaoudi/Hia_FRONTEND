import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/cart/cart.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hive/hive.dart';

class CartViewModel extends ChangeNotifier {
  late Box<Cart> _cartBox;
  Cart? _cart;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  Cart? get cart => _cart;

  int get cartLength => _cart?.items.length ?? 0;

  bool _reOrderLoading = false;
  bool get reOrderLoading => _reOrderLoading;


  void setReOrderLoading (bool value) {
    Debugger.blue('Setting reOrderLoading to $value');
    _reOrderLoading = value;
    notifyListeners();
  }

  CartViewModel() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _cartBox = await Hive.openBox<Cart>('cartBox');
    _cart = _cartBox.get('cart', defaultValue: Cart(items: []));
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addItem(Food? food, int quantity, {Offer? offer})async {
    try {
        bool isAdded = await _cart?.addItem(food, quantity, offer: offer) ?? false;
        return isAdded;
    }catch (e){
      Debugger.red('Error adding item to cart: $e');
      return false;
    }
  }
  
 void removeItem(Food? food , {Offer? offer}) {
    _cart?.removeItem(food, offer: offer);
    notifyListeners();
 }

 //update the quantity of the item
  void updateItemQuantity(Food? food, int quantity, {Offer? offer}) {
    _cart?.updateItemQuantity(food, quantity);
    notifyListeners();
  }

  double getTotalPrice() {
    return _cart?.getTotalPrice() ?? 0.0;
  }

  void clearCart() {
    _cart?.clearCart();
    notifyListeners();
  }

  Future <void> addItems (List<Food> foods) async {
      
    for (var food in foods) {
      await addItem(food, 1);
    }
  }

  Future<void> overrideEstablishmentId(String id) async {
    Future.delayed(const Duration(milliseconds: 2000));
    _cart?.overrideEstablishmentId(id);
    notifyListeners();
  }

}
