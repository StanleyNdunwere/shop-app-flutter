import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'dart:math' as math;

class ProductDetailScreen extends StatelessWidget {
  Product product;

  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    Map<String, Product> productMap = ModalRoute.of(context).settings.arguments;
    this.product = productMap["product"];
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20),
              child: ClipRRect(borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl,
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(product.description),
            Text("\$${product.price.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
