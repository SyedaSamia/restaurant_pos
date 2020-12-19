import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart' as ord;

import '../../screens/edit_staged_order/edit_cart_item_screen.dart';
import '../../screens/menu_screens/menu_checkout.dart';
import '../../utils/size_config.dart';

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
          builder: (_) => AssetGiffyDialog(
                image: Image.asset(
                  'assets/face.gif',
                  fit: BoxFit.cover,
                ),
                title: Text(
                  'You want to cancel this order?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                ),
                entryAnimation: EntryAnimation.BOTTOM_RIGHT,
                onOkButtonPressed: () {
                  Navigator.of(context).pop();
                  stagingOrder
                      .deleteStagingOrder(id)
                      .then((value) => stagingOrder.fetchAndSetStagedOrders());
                },
                onCancelButtonPressed: () {
                  Navigator.of(context).pop();
                },
              ));
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
