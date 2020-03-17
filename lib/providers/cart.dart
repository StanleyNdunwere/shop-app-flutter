import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  int quantity;
  double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  String token;

  Cart(this._items, this.token){

  }

  Map<String, CartItem> get items {
//    notifyListeners();
    return {..._items};
  }

  int get itemCount {
//    notifyListeners();
    return _items.length;
  }

  void addToCart(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items[productId].quantity += 1;
    } else {
      _items[productId] = CartItem(
          id: DateTime.now().toIso8601String(),
          title: title,
          quantity: 1,
          price: 20);
    }
    notifyListeners();
  }

  double get calculateTotalPrice {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItemInstance(String id) {
    if (_items.containsKey(id)) {
      if (_items[id].quantity > 1) {
        _items[id].quantity -= 1;
      } else {
        _items.remove(id);
      }
    }
    return;
  }

  void removeAllItems() {
    this._items = {};
  }
}
