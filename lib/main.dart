import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //this default instance should be used only and only when you need to create a new object
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (context, authProvider, oldProductsObject) {
            return Products(authProvider.token, authProvider.userId,
                (oldProductsObject == null) ? [] : oldProductsObject.items);
          },
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          builder: (context, authProvider, oldCartObject) {
            return Cart((oldCartObject != null) ? oldCartObject.items : {},
                authProvider.token);
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderItems>(
          builder: (context, authData, oldOrderItemsObject) => OrderItems(
              (oldOrderItemsObject != null)
                  ? oldOrderItemsObject.allOrders()
                  : [],
              authData.userId,
              authData.token),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.orange,
              accentColor: Colors.orange,
              primaryColor: Colors.teal,
              fontFamily: "Anton",
            ),
            home: (authData.isAuth)
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (context, loginSnapshot) {
                      return (loginSnapshot.connectionState ==
                              ConnectionState.waiting)
                          ? SplashScreen()
                          : AuthScreen();
                    },
                  ),
//        home: ProductOverviewScreen(),
            routes: {
              "/product_detail_screen": (context) => ProductDetailScreen(),
              "/cart_screen": (context) => CartScreen(),
              "/order_screen": (context) => OrderScreen(),
              "/user_products_screen": (context) => UserProductsScreen(),
              "/edit_product_screen": (context) => EditProductScreen(),
              '/auth': (context) => AuthScreen(),
              '/product_overview_screen': (context) => ProductOverviewScreen(),
            },
          );
        },
      ),
    );
  }
}
