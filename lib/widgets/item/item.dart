import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/models/item_provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';

class Item extends StatelessWidget {
  final count;
  Item(this.count);

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<ItemProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return ListTile(
      //  contentPadding: EdgeInsets.only(top: 15),
      //title: Text('${item.title.toString()}'),
      title: Text('${item.title}'),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.deepPurple,
        child: Text('${count + 1}'),
        /* backgroundImage: NetworkImage(
         item.imageUrl,
        ),*/
      ),
      subtitle: Text('${item.price}'),
      trailing: IconButton(
        icon: Icon(
          Icons.shopping_cart,
          //size: 8,
        ),
        onPressed: () {
          // print(item.itemId);
          cart
              .addItem(
                item.itemId,
                double.parse(item.price),
                item.title,
              )
              .then((value) => cart.fetchCartItem());
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
                  cart.removeSingleItem(item.itemId);
                  cart.fetchCartItem();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
