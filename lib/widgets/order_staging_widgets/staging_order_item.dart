import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart' as ord;
import 'package:flutter/material.dart';
import 'package:restaurantpos/screens/edit_staged_order/edit_cart_item_screen.dart';
import 'package:restaurantpos/screens/menu_screens/menu_checkout.dart';
import 'package:restaurantpos/utils/size_config.dart';

class StagingOrderItem extends StatefulWidget {
  final ord.OrderStagingItemProvider order;
  final num;

  StagingOrderItem(this.order, this.num);
  @override
  _StagingOrderItemState createState() => _StagingOrderItemState();
}

class _StagingOrderItemState extends State<StagingOrderItem> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final stagingOrder = Provider.of<ord.OrderStagingProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);
    void showRemoveDialog(context, String id) {
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
                      "You want to cancel this order",
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
                              stagingOrder.deleteStagingOrder(id).then(
                                      (value) =>
                                      stagingOrder.fetchAndSetStagedOrders());
                            },
                          ),
                        ])
                  ],
                ),
              )));
    }

    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeVertical * 3,
            vertical: SizeConfig.blockSizeHorizontal * 2,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text('${widget.num}')),
                  Text('Table No: '),
                  Text('${widget.order.amount}')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(''),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      print(
                          'printing order in staging order item: ${widget.order.id}');
                      cart.takeCurrentStagedOrderId(widget.order.id);
                      stagingOrder
                          .editStagingOrder(widget.order.id)
                          .then((value) => cart.fetchCartItem())
                          .then((value) => Navigator.of(context)
                          .pushNamed(EditCart.routeName));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showRemoveDialog(context, widget.order.id);
                    },
                  ),
                  RaisedButton(
                    child: Text('Checkout'),
                    onPressed: () {
                      stagingOrder.findOrder(widget.order.id);
                      Navigator.of(context)
                          .pushReplacementNamed(Checkout.routeName);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

