import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';
import 'package:restaurantpos/widgets/checkout_order_item.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';

import 'menu_cart.dart';

class Checkout extends StatelessWidget {
  static const routeName = '/checkout';

  /*final int qnty;
  final String itemName;
  Checkout(this.qnty, this.itemName);*/

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<CheckoutProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        actions: <Widget>[
          BackButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed(Cart.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => CheckoutOrderItem(orderData.orders[i]),
      ),
    );
  }
}
