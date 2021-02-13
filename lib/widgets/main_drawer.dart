import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/auth.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart';
import 'package:restaurantpos/screens/home.page.dart';
import 'package:restaurantpos/screens/menu_screens/order_staging_screen.dart';
import 'package:restaurantpos/widgets/dialogs/logout_dialog.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final user = Provider.of<Auth>(context, listen: false);
    final checkout = Provider.of<CheckoutProvider>(context, listen: false);
    final orderStaging = Provider.of<OrderStagingProvider>(context);
    final navigationDrawerHeader = DrawerHeader(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Stack(children: <Widget>[
          Positioned(
            top: 15,
            left: 16,
            child: Container(
              // color: Colors.black,
              /*decoration: BoxDecoration(
                //   backgroundBlendMode: BlendMode.color,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.white),
              ),*/
              height: 70,
              // width: 200,
              child: Center(
                child: Text(
                  '${user.restaurantName}',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'RobotoCondensed',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 30.0,
              left: 16.0,
              child: user.userFirstName == null
                  ? Text('Waiter Name')
                  : Text("${user.userFirstName} ${user.userLastName}",
                      style: TextStyle(
                          color: Colors.amber[300],
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500))),
          Positioned(
              bottom: 15.0,
              left: 16.0,
              child: user.userEmail == null
                  ? Text('email@email.com')
                  : Text("${user.userEmail}",
                      style: TextStyle(
                          color: Colors.yellow[300],
                          fontSize: 12,
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
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          }),
          /*  buildListTile('Cart', () {
            Navigator.of(context).pushReplacementNamed(Cart.routeName);
          }),*/
          /*buildListTile('Checkout', () {
            Navigator.of(context).pop();
            (cart.totalAmount != 0)
                ? Navigator.of(context).pushReplacementNamed(Checkout.routeName)
                : Fluttertoast.showToast(
                    msg: "Empty Cart! Please add items to checkout",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    // timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blueGrey,
                    textColor: Colors.white,
                    fontSize: 16.0);
          }),*/
          buildListTile('Pending Orders', () {
            Navigator.of(context).pop();
            if (orderStaging.stagingOrders.length > 0) {
              cart.clear();
              Navigator.of(context)
                  .pushReplacementNamed(OrderStaging.routeName);
            } else
              return Fluttertoast.showToast(
                  msg: "No pending orders to checkout!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  // timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0);
          }),
          /* buildListTile('Transaction', () {
            Navigator.of(context).pushReplacementNamed(Transaction.routeName);
          }),*/
          buildListTile('Update to server', () {
            Navigator.of(context).pop();
            if (checkout.checkNullOrder) {
              Fluttertoast.showToast(
                  msg: "There is no order to update!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              final update = checkout.updateCheckoutOrderToServer(user.userId);
              if (update != null) {
                Fluttertoast.showToast(
                    msg: "Updated to server!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blueGrey,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
          }),
          buildListTile('Logout', () {
            showLogoutDialog(context);
          }),
        ],
      ),
    );
  }

/*_showCheckoutDialog(BuildContext context) {
    AlertDialog();
  }*/
}
