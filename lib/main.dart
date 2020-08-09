import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/auth.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/categories_provider.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';
import 'package:restaurantpos/providers/items_provider.dart';
import 'package:restaurantpos/screens/home.page.dart';
import 'package:restaurantpos/screens/login.screen.dart';
import 'file:///H:/AndroidStudio/flutter/Professional/sns/pos_app/new%20one/restaurant_pos/lib/screens/menu_screens/menu_cart.dart';
import 'file:///H:/AndroidStudio/flutter/Professional/sns/pos_app/new%20one/restaurant_pos/lib/screens/menu_screens/menu_checkout.dart';
import 'file:///H:/AndroidStudio/flutter/Professional/sns/pos_app/new%20one/restaurant_pos/lib/screens/menu_screens/menu_transaction.dart';
import 'file:///H:/AndroidStudio/flutter/Professional/sns/pos_app/new%20one/restaurant_pos/lib/screens/menu_screens/order_staging_screen.dart';
import 'package:restaurantpos/screens/splash_screen.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'models/category.dart';
import 'models/item_provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() => null);
  //GetIt.I.registerLazySingleton(() => null);
  //GetIt.instance<>();
}

void main() {
  /* SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitUp,
  ]);*/
  SyncfusionLicense.registerLicense(null);
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
            update: (ctx, auth, previousItems) => ItemsProvider(
                auth.userId, previousItems == null ? [] : previousItems.items),
          ),
          ChangeNotifierProxyProvider<Auth, CategoriesProvider>(
            update: (ctx, auth, previousItems) => CategoriesProvider(
                auth.userId,
                previousItems == null ? [] : previousItems.categories),
          ),
          ChangeNotifierProvider(
            create: (_) => CategoryProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ItemProvider(),
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
          ChangeNotifierProxyProvider<Auth, OrderStagingProvider>(
            update: (ctx, auth, previousCheckoutOrders) => OrderStagingProvider(
                auth.token,
                auth.userId,
                previousCheckoutOrders == null
                    ? []
                    : previousCheckoutOrders.stagingOrders),
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
                    //'/': (ctx) => HomePage(),
                    HomePage.routeName: (ctx) => HomePage(),
                    Cart.routeName: (ctx) => Cart(),
                    Checkout.routeName: (ctx) => Checkout(),
                    Transaction.routeName: (ctx) => Transaction(),
                    OrderStaging.routeName: (ctx) => OrderStaging()
                  },
                  debugShowCheckedModeBanner: false,
                )));
  }
}
