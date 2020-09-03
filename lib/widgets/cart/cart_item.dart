import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/utils/size_config.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      key: ValueKey(productId),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        cart.removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 60,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => cart.addSingleItem(productId),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove,
                        color: Theme.of(context).primaryColor),
                    onPressed: () => cart.removeSingleItem(productId),
                  )
                ],
              )
            ],
          ),
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
