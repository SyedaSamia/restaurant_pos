import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/auth.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';
import 'package:restaurantpos/providers/item_model.dart';
import 'package:restaurantpos/providers/items_provider.dart';
import 'package:restaurantpos/screens/edit_item_screen.dart';
import 'package:restaurantpos/screens/menu_checkout.dart';
import 'package:restaurantpos/screens/menu_transaction.dart';
import 'package:restaurantpos/screens/splash_screen.dart';
import 'screens/home.page.dart';
import 'screens/login.screen.dart';
import 'screens/menu_cart.dart';

/*----------------------------------------------------------
*
* pos app admin version
* firebase as backend
* signup, login
* create item with photo, edit delete
* upload to firebase
*
*----------------------------------------------------------- */

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  final mediaQuery = MediaQuery.of(context);
    //   final isLandscape = mediaQuery.orientation == Orientation.landscape;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, ItemsProvider>(
            update: (ctx, auth, previousItems) => ItemsProvider(auth.token,
                auth.userId, previousItems == null ? [] : previousItems.items),
          ),
          ChangeNotifierProvider(
            create: (_) => ItemModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProxyProvider<Auth, CheckoutProvider>(
            update: (ctx, auth, previousCheckoutOrders) => CheckoutProvider(
                auth.token,
                auth.userId,
                previousCheckoutOrders == null
                    ? []
                    : previousCheckoutOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, child) => MaterialApp(
                  title: 'Restaurant POS app',
                  theme: ThemeData(
                      primarySwatch: Colors.blue,
                      accentColor: Colors.white,
                      // canvasColor: Color.fromRGBO(255, 254, 229, 1),
                      //fontFamily:
                      textTheme: ThemeData.light().textTheme.copyWith(
                          body1: TextStyle(
                            color: Color.fromRGBO(20, 51, 51, 1),
                          ),
                          body2:
                              TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
                          title: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))),
                  home: auth.isAuth
                      ? HomePage()
                      : FutureBuilder(
                          future: auth.tryAutoLogin(),
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : LoginPage(),
                        ),
                  //initialRoute: '/',
                  routes: {
                    // '/': (ctx) => HomePage(),
                    HomePage.routeName: (ctx) => HomePage(),
                    Cart.routeName: (ctx) => Cart(),
                    Checkout.routeName: (ctx) => Checkout(),
                    Transaction.routeName: (ctx) => Transaction(),
                    EditItemScreen.routeName: (ctx) => EditItemScreen()
                  },
                  debugShowCheckedModeBanner: false,
                )));
  }
}

/*
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant POS app'),
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }
}
*/
