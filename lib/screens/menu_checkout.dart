import 'package:flutter/material.dart';
import 'package:restaurantpos/widgets/main_drawer.dart';

class Checkout extends StatelessWidget {
  static const routeName = '/checkout';

  /*final int qnty;
  final String itemName;
  Checkout(this.qnty, this.itemName);*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      drawer: MainDrawer(),
      body: Container(
        child: Card(),
      ),
    );
  }
}
