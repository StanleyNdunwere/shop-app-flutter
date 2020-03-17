import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  CartItem item;

  CartItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 0,
                  color: Colors.teal.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(
                        item.quantity.toString(),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
//                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 0,
                  color: Colors.teal.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      (item.price * item.quantity).toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
