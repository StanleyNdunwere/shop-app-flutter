import 'package:flutter/material.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/providers/product.dart';

class OrderItem extends StatefulWidget {
  Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool showCartDetails = false;

  String currentId = "";

  void toggleCartDetails(String id) {
    setState(() {
      currentId = id;
      showCartDetails = (showCartDetails && currentId == id) ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(widget.order.id),
      margin: EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 0,
                    child: Text("ID: ${widget.order.id}"),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text("Total: "),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: Colors.teal,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.order.totalPrice.toStringAsFixed(2),
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: IconButton(
                        icon: (showCartDetails && widget.order.id == currentId)
                            ? Icon(Icons.expand_less)
                            : Icon(Icons.expand_more),
                        onPressed: () {
                          toggleCartDetails(widget.order.id);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: <Widget>[
                if (showCartDetails && widget.order.id == currentId)
                  Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.teal,
                  ),
                if (showCartDetails && widget.order.id == currentId)
                  ...widget.order.items.map((item) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text("QTY: ${item.quantity.toString()}"),
                            ),
                          ),
                          Flexible(
                            flex: 5,
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text(
                                "${item.title}",
                                softWrap: true,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Text("\$${item.price.toStringAsFixed(2)}"),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
