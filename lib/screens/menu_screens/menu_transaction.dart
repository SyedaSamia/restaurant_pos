import 'package:flutter/material.dart';
import 'package:point_of_sale6/widgets/main_drawer.dart';

class Transaction extends StatelessWidget {
  static const routeName = '/transactions';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      drawer: MainDrawer(),
    );
  }
}
