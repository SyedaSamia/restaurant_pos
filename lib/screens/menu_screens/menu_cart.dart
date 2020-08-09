import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart';
import 'file:///H:/AndroidStudio/flutter/Professional/sns/pos_app/new%20one/restaurant_pos/lib/screens/menu_screens/order_staging_screen.dart';
import 'package:restaurantpos/widgets/dialogs/checkout_dialog.dart';
import 'package:restaurantpos/utils/size_config.dart';
import 'file:///H:/AndroidStudio/flutter/Professional/sns/pos_app/new%20one/restaurant_pos/lib/widgets/cart/cart_item.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';
import 'package:restaurantpos/widgets/order_staging_widgets/staging_order_item.dart';
import 'menu_checkout.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Cart extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final vm = Provider.of<OrderStagingProvider>(context, listen: false);

    void _yesDialogFunctionality(context) {
      vm.addStagingOrderFromCart(
          cart.items.values.toList(), cart.totalAmount, cart.totalVat);
      cart.clear();
      Navigator.of(context).pushReplacementNamed(
        OrderStaging.routeName,
      );
    }

    void _showDialog(context) {
      SizeConfig().init(context);
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
              // backgroundColor: Colors.transparent,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(
                "Are You Sure?",
                style: TextStyle(
                  fontFamily: 'Source Sans Pro',
                  fontSize: SizeConfig.safeBlockHorizontal * 5.5,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
                textAlign: TextAlign.center,
              ),
              content: Container(
                //   height: SizeConfig.blockSizeHorizontal * 30,
                // width: SizeConfig.blockSizeVertical * 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "You want to stage order",
                      //  maxLines: 1,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        color: Color(0xFF606060),
                        fontSize: SizeConfig.safeBlockHorizontal * 4,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeHorizontal * 3,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: new Text("Cancel",
                                style: TextStyle(
                                  fontFamily: 'Source Sans Pro',
                                  color: Theme.of(context).primaryColor,
                                  fontSize: SizeConfig.safeBlockHorizontal * 6,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                )),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: new Text("Yes",
                                style: TextStyle(
                                  fontFamily: 'Source Sans Pro',
                                  color: Theme.of(context).primaryColor,
                                  fontSize: SizeConfig.safeBlockHorizontal * 6,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                )),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _yesDialogFunctionality(context);
                            },
                          ),
                        ])
                  ],
                ),
              )));
    }

    final _floatingActionButton = FloatingActionButton.extended(
      label: Text(
        'Staging Order',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      onPressed: () {
        (cart.totalAmount != 0)
            ? _showDialog(context)
            : /*SnackBar(
                  backgroundColor: Colors.yellow,
                  content: Text('Empty Cart! Please add items to checkout'),
                  duration: Duration(seconds: 3),
                );*/
            Fluttertoast.showToast(
                msg: "Empty Cart! Please add items to stage order",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                // timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white,
                fontSize: 16.0);
      },
      backgroundColor: Theme.of(context).primaryColor,
    );

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Cart'),
            actions: <Widget>[
              BackButton(
                onPressed: () {
                  Fluttertoast.cancel();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          drawer: MainDrawer(),
          body: (cart.totalAmount != 0)
              ? Column(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(25),
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Total',
                                style: TextStyle(fontSize: 20),
                              ),
                              Spacer(),
                              Chip(
                                label: Text(
                                  '\$${(cart.totalAmount - cart.totalVat).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .title
                                        .color,
                                  ),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, i) => CartItem(
                          cart.items.values.toList()[i].id,
                          cart.items.keys.toList()[i],
                          cart.items.values.toList()[i].price,
                          cart.items.values.toList()[i].quantity,
                          cart.items.values.toList()[i].title,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(child: Text('Add items to cart!')),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _floatingActionButton
          // bottomNavigationBar: ,
          ),
    );
  }
}
