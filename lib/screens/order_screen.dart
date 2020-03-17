import 'package:flutter/material.dart';
import 'package:shop_app/providers/order.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: MainDrawer()),
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: Provider.of<OrderItems>(context, listen: false)
            .getAndSetAllOrders(),
        builder: (context, snapshot) {
          Widget finalWidget;
          if (snapshot.connectionState == ConnectionState.waiting) {
            finalWidget = Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orange,
              ),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              finalWidget = Consumer<OrderItems>(
                builder: (context, orders, child) {
                  return ListView.builder(
                      itemCount: orders.allOrders().length,
                      itemBuilder: (context, index) {
                        return OrderItem(orders.allOrders()[index]);
                      });
                },
              );
            } else if (snapshot.error) {
              finalWidget = Text("plenty error dey ground");
            }
          }
          return finalWidget;
        },
      ),
    );
  }
}
