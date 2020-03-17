import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  Future<void> updateItems(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetData(filterProducts: true);
//      return Future.value();
  }
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final items = productsProvider.items;

    return Scaffold(
      drawer: Drawer(
        child: MainDrawer(),
      ),
      appBar: AppBar(
        title: Text("User Products Screen"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed("/edit_product_screen");
            },
          )
        ],
      ),
      //implement pull to refresh
      body: RefreshIndicator(
        onRefresh: (){
          return updateItems(context);
        },
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: ((context, index) {
            return UserProductItem(product: items[index]);
          }),
        ),
      ),
    );
  }
}
