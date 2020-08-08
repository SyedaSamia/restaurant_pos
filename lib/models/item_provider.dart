import 'package:flutter/foundation.dart';

class ItemProvider with ChangeNotifier {
  final String itemId;
  final String title; //basically description = item title;
  //final category;
  final String price;
  // final String imageUrl;
  // final restaurant;

  ItemProvider({
    @required this.itemId,
    @required this.title,
    //  @required this.category,
    @required this.price,
    //   @required this.imageUrl,
    //  @required this.restaurant
  });
}
