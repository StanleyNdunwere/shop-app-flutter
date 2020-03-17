import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FavoritesStatus {
  showOnlyFavorites,
  showAllItems,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showAllItems = true;
  bool hasInitStateRun = false;
  bool isLoadingProducts = false;

  void goToCartScreen(BuildContext context) {
    Navigator.of(context).pushNamed("/cart_screen");
  }

  @override
  void didChangeDependencies() {
    final productsProvider = Provider.of<Products>(context);
    if (!hasInitStateRun) {
      setState(() {
        isLoadingProducts = true;
      });
      productsProvider.fetchAndSetData(filterProducts: false).then((_) {
        setState(() {
          isLoadingProducts = false;
        });
      });
    }
    hasInitStateRun = true;
    super.didChangeDependencies();
  } //  @override
//  void initState() {
//    final productsProvider = Provider.of<Products>(context);
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    print(showAllItems);
    return Scaffold(
      drawer: Drawer(
        child: MainDrawer(),
      ),
      appBar: AppBar(
        title: Text("MyShop"),
        actions: <Widget>[
          //menu settings
          PopupMenuButton(
            icon: Icon(Icons.more),
            onSelected: (selectedValue) {
              setState(() {
                switch (selectedValue) {
                  case FavoritesStatus.showAllItems:
                    showAllItems = true;
                    break;
                  case FavoritesStatus.showOnlyFavorites:
                    showAllItems = false;
                    break;
                }
              });
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("Show only Favorites"),
                  value: FavoritesStatus.showOnlyFavorites,
                ),
                PopupMenuItem(
                    child: Text("Show All Items"),
                    value: FavoritesStatus.showAllItems),
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Badge(
                child: IconButton(
                  onPressed: () {
                    goToCartScreen(context);
                  },
                  icon: Icon(Icons.shopping_cart),
                ),
                value: cart.itemCount.toString(),
              );
            },
          ),
        ],
      ),
      body: (isLoadingProducts)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepOrange,
              ),
            )
          : Container(
              child: ProductsGrid(showAllItems: showAllItems),
            ),
    );
  }
}
