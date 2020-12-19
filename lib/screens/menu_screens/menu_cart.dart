import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final vm = Provider.of<OrderStagingProvider>(context, listen: false);
    bool _checkedValue = false;
    TextEditingController discountController = new TextEditingController();
    bool _percentageDiscountChecked = false;
    double _discount = 0.0;

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
                    * TODO total update ui
                    *
                    * */
                    Container(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 2),
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 17),
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

                    /*  Container(
                      child: Row(
                        children: <Widget>[
                          Text('Discount'),
                          Expanded(
                            child: TextField(
                                // controller: _controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                       labelText:"whatever you want",
                                    hintText: "whatever you want",
                                    icon: Icon(Icons.phone_iphone))),
                          )
                        ],
                      ),
                    ),*/

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
                        ),
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
