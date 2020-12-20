import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart';
import 'package:restaurantpos/screens/menu_screens/order_staging_screen.dart';
import 'package:restaurantpos/utils/size_config.dart';
import 'package:restaurantpos/widgets/cart/cart_item.dart';

import 'item_screen_to_edit.dart';

class EditCart extends StatelessWidget {
  static const routeName = '/editCart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final vm = Provider.of<OrderStagingProvider>(context);
    bool _checkedValue = false;

    TextEditingController discountController = new TextEditingController();
    bool _percentageDiscountChecked = false;

    void _yesDialogFunctionality(context) {
      vm
          .addStagingOrderFromCart(
              cart.items.values.toList(),
              cart.totalAmount,
              cart.totalVat,
              vm.currentDiscountAmount,
              vm.discountPercentageOn,
              cart.carrStagedOrderId)
          .then((value) {
        vm.fetchAndSetStagedOrders();
        cart.clear();
      });
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(
        OrderStaging.routeName,
      );
    }

    void _showDialog(context) {
      SizeConfig().init(context);
      showDialog(
          context: context,
          builder: (_) => AssetGiffyDialog(
                image: Image.asset(
                  'assets/face.gif',
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'Are You Sure?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                ),
                entryAnimation: EntryAnimation.BOTTOM_RIGHT,
                description: Text(
                  'You want to stage order',
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
                onOkButtonPressed: () {
                  Navigator.of(context).pop();
                  _yesDialogFunctionality(context);
                },
                onCancelButtonPressed: () {
                  Navigator.of(context).pop();
                },
              ));
    }

    /* void _showDialog(context) {
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
    }*/

    final _updateOrder = RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Text(
        'Update Order',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        _showDialog(context);
      },
    );

    final _gotoEdit = RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Text(
            'Edit Order',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(EditItemScreen.routeName);
      },
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Edit Cart'),
        ),
        //  drawer: MainDrawer(),
        body: (cart.items.length > 0)
            ? Column(
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    child: Card(
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
                                  '\$${(cart.totalAmount).toStringAsFixed(2)}',
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
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (ctx, i) {
                        //   cart.fetchCartItem();
                        return CartItem(
                          i,
                          cart.items.values.toList()[i].id,
                          cart.items.keys.toList()[i],
                          // cart.items.values.toList()[i].price,
                          // cart.items.values.toList()[i].quantity,
                          cart.items.values.toList()[i].title,
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(child: Text('Add items to cart!')),

        persistentFooterButtons: [_gotoEdit, _updateOrder],
      ),
    );
  }
}
