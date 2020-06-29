import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/items_provider.dart';
import 'package:restaurantpos/widgets/item.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    final itemsData = Provider.of<ItemsProvider>(context);
    final items = itemsData.items;
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: ListView.separated(
        itemCount: items.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: items[i],
          child: Item(),
        ),
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
