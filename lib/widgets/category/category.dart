import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/models/category.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = Provider.of<CategoryProvider>(context, listen: false);

    return ListTile(
      //  contentPadding: EdgeInsets.only(top: 15),
      title: Text('${category.categoryDescription}'),
      //  title: Text('{category.data}'),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.deepPurple,
        /*backgroundImage: NetworkImage(
         category.imageUrl,
        ), */
      ),
      //subtitle: Text(category.price),
    );
  }
}
