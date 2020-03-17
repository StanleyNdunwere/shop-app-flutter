import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductItem extends StatelessWidget {
  void openProductItemDetails(BuildContext context, Product productItem) {
    Navigator.of(context).pushNamed("/product_detail_screen",
        arguments: {"product": productItem});
  }

  @override
  Widget build(BuildContext context) {
    final Product productItem = Provider.of<Product>(context);
    final Cart cartProvider = Provider.of<Cart>(context, listen: false);
    final Products products = Provider.of<Products>(context);

    return InkWell(
      onTap: () {
        openProductItemDetails(context, productItem);
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 6,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: Image.network(
                productItem.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                height: 35,
                padding: EdgeInsets.all(5),
                width: double.infinity,
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        products.toggleFavoriteStatus(product: productItem);
                      },
                      child: FittedBox(
                        child: (!productItem.isFavorite)
                            ? Icon(
                                Icons.favorite,
                                color: Colors.white70,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.yellow,
                              ),
                      ),
                    ),
                    Text(
                      productItem.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                    InkWell(
                      onTap: () {
                        cartProvider.addToCart(productItem.id,
                            productItem.price, productItem.title);
                        //how to use snackbar in flutter
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.teal,
                            elevation: 6,
                            duration: Duration(seconds: 3),
                            content:
                                Text("The Item was added to cart successfully"),
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () {
                                cartProvider
                                    .removeSingleItemInstance(productItem.id);
                              },
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
