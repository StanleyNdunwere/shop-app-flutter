import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context, listen: false);
    return Column(
      children: <Widget>[
        Image.asset(
          "assets/images/headshot.jpg",
          fit: BoxFit.cover,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/order_screen");
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.payment,
                    color: Colors.teal,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Orders"),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.home,
                    color: Colors.teal,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Home"),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/user_products_screen");
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.store_mall_directory,
                    color: Colors.teal,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text("User Products Screen"),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed("/");
            authProvider.logout();
//
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.teal,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Logout"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
