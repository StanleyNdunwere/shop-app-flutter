import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  String token;
  String userId;

  Products(String token, String userId, List<Product> items) {
    _items = items;
    this.userId = userId;
    this.token = token;
  }

  String getToken() {
    return token;
  }

  String getUserId() {
    return userId;
  }

  void toggleFavoriteStatus({Product product}) {
    (product.isFavorite)
        ? product.isFavorite = false
        : product.isFavorite = true;
    setFavorite(product, product.isFavorite, token: token, userId: userId);
    notifyListeners();
  }

  void setFavorite(Product product, bool isFavorite,
      {String userId, String token}) async {
    String url =
        'https://flutter-app-test-c322b.firebaseio.com/usersFavorites/$userId/${product.id}.json?auth=$token';
    await setIsFavorite(product.id, product,
        isFavorite: isFavorite, userId: userId, favoriteUrl: url);
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> getFavoriteItems() {
    return [..._items].where((product) {
      return product.isFavorite == true;
    }).toList();
  }

  Future<void> fetchAndSetData({bool filterProducts : false}) async {
    final String filterCondition =  (filterProducts)? '&orderBy="creatorId"&equalTo="$userId"' : "";
    final url =
        'https://flutter-app-test-c322b.firebaseio.com/products.json?auth=$token$filterCondition';
    List<Product> loadedProducts = [];
    try {
      final response = await http.get(url);
      final Map<String, dynamic> returnedData = json.decode(response.body);
      String favUrl =
          'https://flutter-app-test-c322b.firebaseio.com/usersFavorites'
          '/$userId/.json?auth=$token';
      final favorites = await http.get(favUrl);
      final favoritesData = json.decode(favorites.body);

      returnedData.forEach((prodId, value) {
        loadedProducts.add(
          Product(
            price: value["price"],
            imageUrl: value["imageUrl"],
            description: value["description"],
            title: value["title"],
            isFavorite: (favoritesData[prodId]== null)? false: favoritesData[prodId],
            id: prodId,
          ),
        );
        _items = (loadedProducts);
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct({Product item, String id}) {
    final url =
        'https://flutter-app-test-c322b.firebaseio.com/products.json?auth=$token';
    int index = _items.indexWhere((item) {
      return id == item.id;
    });
    if (index < 0) {
      item.id = DateTime.now().millisecondsSinceEpoch.toString();
      _items.add(item);
      return http
          .post(
        url,
        body: json.encode({
          "id": item.id,
          "title": item.title,
          "description": item.description,
          "imageUrl": item.imageUrl,
          "price": item.price,
          "creatorId":userId,
        }),
      )
          .catchError((error) {
        throw error;
      });
    } else {
      print("here in update1");
      return updateProduct(
        id,
        item,
      );
    }
  }

  Future<void> updateProduct(String id, Product item,
      {bool isFavorite, String userId, String favoriteUrl}) {
    String url =
        'https://flutter-app-test-c322b.firebaseio.com/products/$id.json?auth=$token';

    return http
        .patch(
      url,
      body: json.encode(
        {
          "title": item.title,
          "description": item.description,
          "imageUrl": item.imageUrl,
          "price": item.price,
        },
      ),
    )
        .then((response) {
      print(response.body.toString());
      fetchAndSetData();
      print("here in update3");
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      throw error;
    });
  }

  Future<void> setIsFavorite(String id, Product item,
      {bool isFavorite, String userId, String favoriteUrl}) async {
    String url = favoriteUrl;
    final response = await http.put(
      url,
      body: json.encode(
        isFavorite,
      ),
    );
    print(response.body);
  }

  Future<void> removeProduct(String id) async {
    print("heree delee");
    final String url =
        'https://flutter-app-test-c322b.firebaseio.com/products/$id.json?auth=$token';

    _items.removeWhere((item) {
      return id == item.id;
    });
    final response = await http.delete(url);
    await fetchAndSetData();
    notifyListeners();
    print(response.statusCode);
    if (response.statusCode >= 400) {
      throw Exception("Error in deletion");
    }
  }
}
