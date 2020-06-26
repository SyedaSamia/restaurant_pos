import 'package:flutter/material.dart';
import 'package:restaurantpos/screens/home.page.dart';
import 'package:restaurantpos/screens/menu_cart.dart';
import 'package:restaurantpos/screens/menu_checkout.dart';
import 'package:restaurantpos/screens/menu_transaction.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationDrawerHeader = DrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 30.0,
              left: 16.0,
              child: Text("Waiter Name",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w500))),
          Positioned(
              bottom: 15.0,
              left: 16.0,
              child: Text("waitermail@domain.com",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500))),
        ]));
    Widget buildListTile(String title, Function tapHandler) {
      return ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: tapHandler,
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          navigationDrawerHeader,
          buildListTile('Home', () {
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          }),
          buildListTile('Cart', () {
            Navigator.of(context).pushReplacementNamed(Cart.routeName);
          }),
          buildListTile('Checkout', () {
            Navigator.of(context).pushReplacementNamed(Checkout.routeName);
          }),
          buildListTile('Transaction', () {
            Navigator.of(context).pushReplacementNamed(Transaction.routeName);
          }),
          buildListTile('Update to server', () {}),
          buildListTile('Logout', () {}),
        ],
      ),
    );
  }
}
