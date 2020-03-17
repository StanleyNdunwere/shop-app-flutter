import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cartProvider = Provider.of<Cart>(context);
    final orderItemsProvider = Provider.of<OrderItems>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
//      body: Text("inside this view what the fuck"),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total: ",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Card(
                        color: Colors.teal,
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "\S${cartProvider.calculateTotalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Order orderItem = Order(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              totalPrice: cartProvider.calculateTotalPrice,
                              items: cartProvider.items.values.toList());
                          orderItemsProvider.addOrders(orderItem);
                          cartProvider.removeAllItems();
                          Navigator.of(context)
                              .pushReplacementNamed("/order_screen");
                        },
                        child: Text(
                          "ORDER NOW",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(5),
              itemCount: cartProvider.itemCount,
              itemBuilder: (context, index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) {
                    return showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          elevation: 6,
                          backgroundColor: Colors.white70,
                          title: Text(
                            "Are you sure you want to delete this?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          content: Text(
                            "Delete for ever!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop(true);
                              },
                              child: Text(
                                "Yes",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop(false);
                              },
                              child: Text(
                                "No",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    cartProvider
                        .removeItem(cartProvider.items.keys.toList()[index]);
                  },
                  key: ValueKey(cartProvider.items.keys.toList()[index]),
                  background: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.teal,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white70,
                        )),
                  ),
                  child:
                      CartItemWidget(cartProvider.items.values.toList()[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
