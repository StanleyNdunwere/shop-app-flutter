import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  List<Product> loadedProducts;

  bool showAllItems = true;

  ProductsGrid({this.showAllItems});

  ProductsGrid.old(this.loadedProducts);

  @override
  Widget build(BuildContext context) {
    Products productsListener = Provider.of<Products>(context);
    loadedProducts = (showAllItems)
        ? productsListener.items
        : productsListener.getFavoriteItems();
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: loadedProducts.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          //this second constructor MUST be used only and only when you need to pass your own ALREADTY CREATED object
          // i.e., in this case we already have the created product inside the list so we must use the .value constructor
          return ChangeNotifierProvider.value(
            value: loadedProducts[index]
              ..setToken(productsListener.getToken())
              ..setUserId(productsListener.getUserId()),
            child: Container(
              child: ProductItem(),
            ),
          );
        });
  }
}
