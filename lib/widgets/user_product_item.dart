import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  Product product;

  UserProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    final scaffold = Scaffold.of(context);
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(product.imageUrl),
                ),
              ),
              Flexible(fit: FlexFit.loose, child: Text(product.title)),
              Flexible(
                fit: FlexFit.loose,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/edit_product_screen",
                        arguments: {"product": product});
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.teal,
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: IconButton(
                  onPressed: () {
                    productProvider
                        .removeProduct(product.id)
                        .then((response) {
                      scaffold.showSnackBar(SnackBar(
                        content: Text("deleted Successfully"),
                      ));
                    })
                        .catchError((error) {
                      scaffold.showSnackBar(SnackBar(
                        content: Text("failed to delete"),
                      ));
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
