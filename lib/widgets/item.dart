import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/item_provider.dart';
import 'package:restaurantpos/providers/items_provider.dart';
import 'package:restaurantpos/screens/edit_item_screen.dart';

class Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<ItemProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    return ListTile(
        //  contentPadding: EdgeInsets.only(top: 15),
        isThreeLine: true,
        title: Text('${item.title}'),
        subtitle: Text(item.price.toString()),
        leading: IconButton(
          icon: Icon(
            Icons.shopping_cart,
            //size: 8,
          ),
          onPressed: () {
            cart.addItem(item.id, item.price, item.title);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Added item to cart!',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(item.id);
                  },
                ),
              ),
            );
          },
        ),
        trailing: Wrap(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditItemScreen.routeName, arguments: item.id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () {
                Provider.of<ItemsProvider>(context, listen: false)
                    .deleteItem(item.id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ));
  }
}
