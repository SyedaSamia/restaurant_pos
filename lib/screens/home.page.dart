import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';
import 'package:restaurantpos/providers/item_provider.dart';
import 'package:restaurantpos/providers/items_provider.dart';
import 'package:restaurantpos/screens/category_screen.dart';
import 'package:restaurantpos/screens/edit_item_screen.dart';
import 'package:restaurantpos/screens/menu_checkout.dart';
import 'package:restaurantpos/screens/menu_transaction.dart';
import 'package:restaurantpos/screens/stock_screen.dart';
import 'package:restaurantpos/widgets/badge.dart';
import 'package:restaurantpos/widgets/homehome.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';

import 'item_screen.dart';
import 'menu_cart.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ItemsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ItemProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CheckoutProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.white,
            // canvasColor: Color.fromRGBO(255, 254, 229, 1),
            //fontFamily:
            textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                body2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                title: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        home: HomeHome(),
        //initialRoute: '/',
        routes: {
          // '/': (ctx) => HomePage(),
          HomePage.routeName: (ctx) => HomePage(),
          Cart.routeName: (ctx) => Cart(),
          Checkout.routeName: (ctx) => Checkout(),
          Transaction.routeName: (ctx) => Transaction(),
          EditItemScreen.routeName: (ctx) => EditItemScreen()
        },
        /*onGenerateRoute: (settings) {
          print(settings.arguments);
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (ctx) => HomePage(),
          );
        },*/
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
