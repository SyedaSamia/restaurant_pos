import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/order_staging_provider.dart' as ord;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'file:///H:/AndroidStudio/flutter/Professional/sns/pos_app/new%20one/restaurant_pos/lib/screens/menu_screens/menu_checkout.dart';
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
                  RaisedButton(
                    child: Text('Checkout'),
                    onPressed: () {
                      stagingOrder.findOrder(widget.order.id);
                      // stagingOrder.idToDeleteStagingOrder(widget.order.id);
                      // stagingOrder.deleteOrder(widget.order.id);
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
