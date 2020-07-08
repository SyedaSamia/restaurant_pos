import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/screens/category_screen.dart';
import 'package:restaurantpos/screens/edit_item_screen.dart';
import 'package:restaurantpos/screens/item_screen.dart';
import 'package:restaurantpos/screens/menu_cart.dart';
import 'package:restaurantpos/screens/stock_screen.dart';
import 'package:restaurantpos/widgets/badge.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('Items'),
                ),
                Tab(
                  child: Text('Stock'),
                ),
                Tab(child: Text('Categories')),
              ],
            ),
            actions: <Widget>[
              Consumer<CartProvider>(
                builder: (_, cart, ch) => Badge(
                  child: ch,
                  value: cart.itemCount.toString(),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Cart.routeName);
                  },
                ),
              ),
            ],
          ),
          drawer: MainDrawer(),
          body: TabBarView(children: <Widget>[
            ItemScreen(),
            StockScreen(),
            CategoryScreen()
          ]),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditItemScreen.routeName);
            },
          ),
        ));
  }
}
