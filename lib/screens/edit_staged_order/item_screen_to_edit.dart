import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/screens/tab_screens/item_screen.dart';
import 'package:restaurantpos/utils/size_config.dart';
import 'package:restaurantpos/widgets/badge.dart';
import '../menu_screens/menu_cart.dart';
import 'edit_cart_item_screen.dart';

class EditItemScreen extends StatelessWidget {
  static const routeName = '/editItem';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Edit Items'),
          actions: [
            Consumer<CartProvider>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditCart.routeName);
                },
              ),
            )
          ],
          automaticallyImplyLeading: false,
        ),
        body: ItemScreen(),
      ),
    );
  }
}
