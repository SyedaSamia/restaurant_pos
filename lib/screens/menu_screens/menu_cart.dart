import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart';
import 'package:restaurantpos/utils/size_config.dart';
import 'package:restaurantpos/widgets/cart/cart_item.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';

import 'order_staging_screen.dart';

class Cart extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _percentageDiscountChecked = false;
  double _discount = 0.0;
  bool _checkedValue = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final vm = Provider.of<OrderStagingProvider>(context, listen: false);

    TextEditingController discountController = new TextEditingController();

    var _tot = cart.totalAmount;

    changeTotal(_val) {
      setState(() {
        _tot = _val;
      });
    }

    void _yesDialogFunctionality(context) {
      cart.changeCheckVat(_checkedValue);
      vm
          .addStagingOrderFromCart(
              cart.items.values.toList(),
              cart.totalAmount,
              cart.totalVat,
              _discount,
              _percentageDiscountChecked,
              DateTime.now().toString())
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
            : Fluttertoast.showToast(
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
                  //  Fluttertoast.cancel();
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
          drawer: MainDrawer(),
          body: (cart.itemCount > 0)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /*
                    *
                    * Vat option starts
                    *
                    * */

                    StatefulBuilder(
                        builder: (BuildContext ctx, StateSetter setState) {
                      return CheckboxListTile(
                        title: Text('Add Vat(15%)'),
                        activeColor: Colors.blue,
                        value: _checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            _checkedValue = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }),

                    /*
                    *
                    * Vat option ends
                    *
                    * */

                    /*
                    * Discount Option starts
                    *
                    * */
                    Row(children: [
                      StatefulBuilder(
                          builder: (BuildContext ctx, StateSetter setState) {
                        return Container(
                          width: SizeConfig.blockSizeHorizontal * 55,
                          height: SizeConfig.blockSizeVertical * 5,
                          child: CheckboxListTile(
                            title: Text('Discount (%)'),
                            activeColor: Colors.blue,
                            value: _percentageDiscountChecked,
                            onChanged: (newValue) {
                              setState(() {
                                _percentageDiscountChecked = newValue;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      }),
                      Container(
                          width: SizeConfig.blockSizeHorizontal * 30,
                          height: SizeConfig.blockSizeVertical * 5,
                          child: TextField(
                            controller: discountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: 'Amount'),
                            onChanged: (value) {
                              _discount = double.parse(discountController.text);
                            },
                          )),
                    ]),

                    /*Discount option ends*/

                    /*
                    *
                    * Total starts
                    *
                    * */

                    Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 2),
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
                                    '\$${(_tot).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .title
                                          .color,
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ],
                            )),
                      ),
                    ),

                    /*
                    *
                    * Total ends
                    *
                    * */

                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, i) => CartItem(
                            i,
                            cart.items.values.toList()[i].id,
                            cart.items.keys.toList()[i],
                            //    cart.items.values.toList()[i].price,
                            //   cart.items.values.toList()[i].quantity,
                            cart.items.values.toList()[i].title,
                            updateCounter: changeTotal),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 50,
                  child: Center(
                      child: Container(
                          height: 15, child: Text('Add items to cart!')))),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _floatingActionButton
          // bottomNavigationBar: ,
          ),
    );
  }
}
