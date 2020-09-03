import 'package:flutter/material.dart';
import 'package:point_of_sale6/providers/cart_provider.dart';
import 'package:point_of_sale6/providers/order_staging_provider.dart';
import 'file:///H:/AndroidStudio/flutter/Professional/sns/pos_app/point_of_sale6/lib/screens/edit_staged_order/edit_cart_item_screen.dart';
import 'package:point_of_sale6/screens/tab_screens/item_screen.dart';
import 'package:point_of_sale6/utils/size_config.dart';
import 'package:point_of_sale6/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../menu_screens/menu_cart.dart';

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
