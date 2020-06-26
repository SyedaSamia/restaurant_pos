import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  //final Image itemImage;
  final String itemName;
  final double itemPrice;
  final int itemQuantity;

  CartItem(this.id, this.itemName, this.itemPrice, this.itemQuantity);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              itemName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('P: ${itemPrice.toString()}'),
            Text('Qty: ${itemQuantity.toString()}')
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
