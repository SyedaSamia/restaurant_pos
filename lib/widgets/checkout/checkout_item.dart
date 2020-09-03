import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  CheckoutItem(
    this.id,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('$quantity x'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('$price tk'),
          trailing: Text('Total: \$${(price * quantity)}'),
        ),
      ),
    );

    /*InkWell(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('P: ${price.toString()}'),
            Text('Qty: ${quantity.toString()}'),
            Text('Total: ${(price * quantity)}')
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );*/
  }
}
