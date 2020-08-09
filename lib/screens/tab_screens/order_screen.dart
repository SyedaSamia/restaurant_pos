import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/auth.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';
import 'package:restaurantpos/utils/size_config.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restaurantpos/widgets/order/checkout_order_item.dart';
import '../menu_screens/menu_cart.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    pr.style(message: 'Updating Server...');

    final checkout = Provider.of<CheckoutProvider>(context, listen: false);
    final user = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      drawer: MainDrawer(),
      body: Consumer<CheckoutProvider>(
        builder: (ctx, orderData, child) => orderData.orders.length > 0
            ? ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx, i) =>
                    CheckoutOrderItem(orderData.orders[i], i + 1),
              )
            : Center(
                child: Text('No order is added!'),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: SizeConfig.blockSizeHorizontal * 40,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    )),
                color: Theme.of(context).primaryColor,
                child: Text('Update Order'),
                onPressed: () {
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
                    pr.show();
                    final update =
                        checkout.updateCheckoutOrderToServer(user.userId);

                    if (update != null) {
                      Future.delayed(Duration(seconds: 1))
                          .then((value) => pr.hide().whenComplete(() => {
                                Fluttertoast.showToast(
                                    msg: "Updated to server!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blueGrey,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                              }));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      //  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //    floatingActionButton: _floatingActionButton
    );
  }
}
