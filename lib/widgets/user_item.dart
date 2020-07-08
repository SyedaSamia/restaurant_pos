/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/items_provider.dart';
import 'package:restaurantpos/screens/edit_item_screen.dart';

class UserItem extends StatelessWidget {
  final String id;
  final String title;
//  final String imageUrl;

  UserItem(
    this.id,
    this.title,
    //this.imageUrl
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      */
/* leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),*/ /*

      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditItemScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Provider.of<ItemsProvider>(context, listen: false)
                    .deleteItem(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
*/
