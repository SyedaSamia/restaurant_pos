import 'package:flutter/material.dart';
import 'package:restaurantpos/screens/category_screen.dart';
import 'package:restaurantpos/screens/menu_checkout.dart';
import 'package:restaurantpos/screens/menu_transaction.dart';
import 'package:restaurantpos/screens/stock_screen.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';

import 'item_screen.dart';
import 'menu_cart.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    return MaterialApp(
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
      home: DefaultTabController(
          length: 3,
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
              ),
              drawer: MainDrawer(),
              body: TabBarView(children: <Widget>[
                ItemScreen(),
                StockScreen(),
                CategoryScreen()
              ]))),
      //initialRoute: '/',
      routes: {
        // '/': (ctx) => HomePage(),
        HomePage.routeName: (ctx) => HomePage(),
        Cart.routeName: (ctx) => Cart(),
        Checkout.routeName: (ctx) => Checkout(),
        Transaction.routeName: (ctx) => Transaction()
      },
      onGenerateRoute: (settings) {
        print(settings.arguments);
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => HomePage(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
