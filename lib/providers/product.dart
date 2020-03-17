import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/products.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;
  String _token;
  String _userId;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite: false,
  });

//  void toggleFavoriteStatus({Product product}) {
//    (isFavorite) ? isFavorite = false : isFavorite = true;
//    Products.setFavorite(product, isFavorite,
//        token: (_token != null) ? _token : '',
//        userId: (_userId != null) ? _userId : "");
//    notifyListeners();
//  }

  void setToken(String token) {
    this._token = token;
  }

  void setUserId(String userId) {
    this._userId = userId;
  }
}
