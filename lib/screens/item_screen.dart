import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantpos/cart_item.dart';
import 'package:restaurantpos/dummy_data.dart';

class ItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: DUMMY_CART.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(DUMMY_CART[index].itemName),
                Text(DUMMY_CART[index].itemPrice.toString()),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }
}
