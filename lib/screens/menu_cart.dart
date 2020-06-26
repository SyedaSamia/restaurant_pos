import 'package:flutter/material.dart';
import 'package:restaurantpos/cart_item.dart';
import 'package:restaurantpos/dummy_data.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';

class Cart extends StatelessWidget {
  static const routeName = '/cart';
  final totalItem = 6;
  //final double totalBill = (itemPrice * itemQuantity);
  final totalCost = 10000;
  /*final routeArgs = ModalRoute.of(context).settings.arguments as String;
  final menuTitle = routeArgs['title'];
*/
  @override
  Widget build(BuildContext context) {
    final _floatingActionButton = FloatingActionButton.extended(
      label: Text(
        '${totalItem} item/items = ${totalCost}',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      icon: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      onPressed: () {},
      backgroundColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        drawer: MainDrawer(),
        body: GridView(
          padding: EdgeInsets.all(20),
          children: DUMMY_CART
              .map((e) =>
                  CartItem(e.id, e.itemName, e.itemPrice, e.itemQuantity))
              .toList(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              childAspectRatio: 5 / 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _floatingActionButton

        // bottomNavigationBar: ,
        );
  }
}

/*
GridView.builder(
gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: 2,
childAspectRatio: MediaQuery.of(context).size.width /
(MediaQuery.of(context).size.height / 4),
),
itemCount: DUMMY_CART.length,
itemBuilder: (context, index) {
return GridTile(child: Text(items[index]));
},
),*/
