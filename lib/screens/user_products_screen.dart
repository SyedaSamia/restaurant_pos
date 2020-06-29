import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/items_provider.dart';
import 'package:restaurantpos/screens/edit_item_screen.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';
import 'package:restaurantpos/widgets/user_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ItemsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditItemScreen.routeName);
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserItem(
                productsData.items[i].id,
                productsData.items[i].title,
                //   productsData.items[i].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
