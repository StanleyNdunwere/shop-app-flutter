import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class Order {
  String id;
  double totalPrice;
  List<CartItem> items;


  Order({this.id, this.totalPrice, this.items});
}

class OrderItems with ChangeNotifier {
  List<Order> _orders = [];
  String reqToken;
  String userId;
  OrderItems(this._orders, this.userId, this.reqToken){
  }

  Future<void> addOrders(Order order) async {
    final String url =
        'https://flutter-app-test-c322b.firebaseio.com/userOrders/$userId.json?auth=$reqToken&orderBy="creatorId"&equalTo="$userId"';
    try {
      final response = await http.post(url,
          body: json.encode({
            "id": order.id,
            "totalPrice": order.totalPrice,
            "items": [
              ...order.items.map(
                (item) {
                  return {
                    "id": item.id,
                    "quantity": item.quantity,
                    "title": item.title,
                    "price": item.price,
                  };
                },
              ).toList(),
            ],
          }));
      _orders.insert(0, order);
      notifyListeners();
      if (response.statusCode >= 400) {
        throw Exception("unable to save order");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAndSetAllOrders() async {
    List<Order> loadedOrders = [];
    final String url =
        'https://flutter-app-test-c322b.firebaseio.com/userOrders/$userId.json?auth=$reqToken';
    final response = await http.get(url);
    print(json.decode(response.body));
    if (response.body != null) {
      final Map<String, dynamic> allOrders = json.decode(response.body);
      allOrders.forEach((key, values) {
        loadedOrders.add(
            Order(id: values["id"], totalPrice: values["totalPrice"], items: [
          ...(values["items"]).map((value) {
            return CartItem(
              id: value["id"],
              title: value["title"],
              price: value["price"],
              quantity: value["quantity"],
            );
          }).toList(),
        ]));
        _orders = loadedOrders;
        notifyListeners();
      });
    }
  }

  List<Order> allOrders() {
    return ([..._orders]);
  }
}
