import 'dart:math';
import 'package:flutter/material.dart';
import 'package:point_of_sale6/models/order.dart' as ord;

class CheckoutOrderItem extends StatefulWidget {
//  final ord.CheckoutItemProvider order;
  final ord.OrderModel order;
  final num;

  CheckoutOrderItem(this.order, this.num);

  @override
  _CheckoutOrderItemState createState() => _CheckoutOrderItemState();
}

class _CheckoutOrderItemState extends State<CheckoutOrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(child: Text('${widget.num}')),
            title: Text('${widget.order.totalAmount} tk'),
            subtitle: Text('${widget.order.orderDate}'
                //DateFormat('dd/MM/yyyy hh:mm').format(widget.order.orderDate),
                ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 200),
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${prod.title}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${prod.quantity}x ${prod.price}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
