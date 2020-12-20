import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/utils/size_config.dart';

class CartItem extends StatefulWidget {
  final int i;
  final String id;
  final String productId;
  // final double price;
  // final int quantity;
  final String title;
  final updateCounter;

  CartItem(
      this.i,
      this.id,
      this.productId,
      //  this.price,
      //  this.quantity,
      this.title,
      {this.updateCounter});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final cart = Provider.of<CartProvider>(
      context, /*listen: false*/
    );
    return Dismissible(
      key: ValueKey(widget.productId),
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
        cart.removeItem(widget.productId);
        widget.updateCounter(cart.totalAmount);
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
                      child: Text(
                          '${cart.items.values.toList()[widget.i].quantity} x'),
                    ),
                  ),
                ),
                title: Text(widget.title),
                subtitle:
                    Text('${cart.items.values.toList()[widget.i].price} tk'),
                trailing: Text(
                    'Total: \$${(cart.items.values.toList()[widget.i].price * cart.items.values.toList()[widget.i].quantity)}'),
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
                    onPressed: () {
                      setState(() {
                        print(
                            'productId in cartItem to increase qty ${widget.productId}');
                        cart.addSingleItem(widget.productId);
                        widget.updateCounter(cart.totalAmount);
                      });
                      //quantity
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.remove,
                        color: Theme.of(context).primaryColor),
                    onPressed: () => setState(() {
                      cart.removeSingleItem(widget.productId);
                      widget.updateCounter(cart.totalAmount);
                    }),
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
