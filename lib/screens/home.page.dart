import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/utils/size_config.dart';
import 'package:restaurantpos/widgets/badge.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';

import 'tab_screens/category_screen.dart';
import 'tab_screens/item_screen.dart';
import 'menu_screens/menu_cart.dart';
import 'tab_screens/order_screen.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => AssetGiffyDialog(
              image: Image.asset(
                'assets/face.gif',
                fit: BoxFit.cover,
              ),
              title: Text(
                'Do you want to exit?',
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              entryAnimation: EntryAnimation.BOTTOM_RIGHT,

              onOkButtonPressed: () {
                Navigator.of(context).pop(true);
              },
            )) ??
          false;

    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      /*   onWillPop: (){
        Navigator.of(context).pop(true);
      },*/
      child: DefaultTabController(
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
                    child: Text('Orders'),
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
              OrderScreen(),
              CategoryScreen()
            ]),
          )),
    );
  }
}
