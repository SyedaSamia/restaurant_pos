import 'package:flutter/material.dart';
import 'package:point_of_sale6/providers/cart_provider.dart';
import 'package:point_of_sale6/providers/order_staging_provider.dart';
import 'package:point_of_sale6/utils/size_config.dart';
import 'package:point_of_sale6/widgets/main_drawer.dart';
import 'package:point_of_sale6/widgets/order_staging_widgets/staging_order_item.dart';
import 'package:provider/provider.dart';

import '../home.page.dart';

class OrderStaging extends StatelessWidget {
  static const routeName = '/staging';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed(
          HomePage.routeName,
        );
      },
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Pending Orders'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                cart.clear();
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              },
            )
          ],
        ),
        body: Consumer<OrderStagingProvider>(
          builder: (ctx, orderData, child) => orderData.stagingOrders.length > 0
              ? ListView.builder(
                  itemCount: orderData.stagingOrders.length,
                  itemBuilder: (ctx, i) {
                    return StagingOrderItem(orderData.stagingOrders[i], i + 1);
                  })
              : Center(
                  child: Text('No order is in pending!'),
                ),
        ),

        /*FutureBuilder(
          future: Provider.of<CheckoutProvider>(context, listen: false)
              .fetchAndSetCheckoutOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // ...
                // Do error handling stuff
                return Center(
                  child: Text('An error occurred! ${dataSnapshot.error}'),
                );
              } else {
                return Consumer<CheckoutProvider>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) =>
                        CheckoutOrderItem(orderData.orders[i]),
                  ),
                );
              }
            }
          },
        ),*/
      ),
    );
  }
}
