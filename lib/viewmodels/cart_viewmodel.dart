import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/cart/cart.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/models/product.model.dart';
import 'package:hive/hive.dart';
import 'package:hia/viewmodels/offer.viewmodel.dart';

class CartViewModel extends ChangeNotifier {
  late Box<Cart> _cartBox;
  Cart? _cart;
  bool _isLoading = true;
  final OfferViewModel offerViewModel;

  bool get isLoading => _isLoading;
  Cart? get cart => _cart;
  int get cartLength => _cart?.items.length ?? 0;

  bool _reOrderLoading = false;
  bool get reOrderLoading => _reOrderLoading;

  void setReOrderLoading(bool value) {
    Debugger.blue('Setting reOrderLoading to $value');
    _reOrderLoading = value;
    notifyListeners();
  }

  CartViewModel({required this.offerViewModel}) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _cartBox = await Hive.openBox<Cart>('cartBox');
    _cart = _cartBox.get('cart', defaultValue: Cart(items: []));
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addItem(Food? food, int quantity, {Offer? offer, Product? product}) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (offer != null) {
        // Check if offer is still available
        final offerIndex = offerViewModel.offers.indexWhere((o) => o.id == offer.id);
        if (offerIndex != -1) {
          final currentOffer = offerViewModel.offers[offerIndex];
          if (currentOffer.quantity <= 0) {
            throw Exception('Cette offre n\'est plus disponible');
          }

          // Decrement offer quantity
         // await offerViewModel.decrementOfferQuantity(offer.id);
        }
      }

      // Initialize cart if null
      _cart ??= Cart(items: []);

      // Add item to cart
      _cart!.addItem(food, quantity, offer: offer, product: product);

      notifyListeners();
      Debugger.green('Article ajouté au panier avec succès');
      return true;

    } catch (e) {
      Debugger.red('Erreur lors de l\'ajout au panier: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeItem(Food? food, {Offer? offer, Product? product}) {
    _cart?.removeItem(food, offer: offer, product: product);
    notifyListeners();
  }

  void updateItemQuantity(Food? food, int quantity, {Offer? offer, Product? product}) {
    if (food != null) {
      _cart?.updateItemQuantity(food, quantity, offer: offer, product: product);
    } else if (offer != null) {
      _cart?.updateItemQuantity(null, quantity, offer: offer, product: null);
    } else if (product != null) {
      _cart?.updateItemQuantity(null, quantity, offer: null, product: product);
    }
    notifyListeners();
  }

  double getTotalPrice() {
    return _cart?.getTotalPrice() ?? 0.0;
  }

  void clearCart() {
    _cart?.clearCart();
    notifyListeners();
  }

  Future<void> addItems(List<Food> foods, {Offer? offer}) async {
    for (var food in foods) {
      _cart?.addItem(food, 1, offer: offer);
    }
    notifyListeners();
  }

  Future<void> addItemsProducts(List<Product> products) async {
    for (var product in products) {
      await addItem(null, 1, offer: null, product: product);
    }
  }

  Future<void> overrideEstablishmentId(String id) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    _cart?.overrideEstablishmentId(id);
    notifyListeners();
  }

}
