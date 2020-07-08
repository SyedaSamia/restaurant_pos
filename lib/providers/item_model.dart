import 'package:flutter/foundation.dart';

class ItemModel with ChangeNotifier {
  final String id;
  final String title;
  final String category;
  final double price;
  final String imageUrl;
  final String restaurant = 'Abc restaurant';

  ItemModel({
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.price,
    @required this.imageUrl,
    // @required this.restaurant
  });
}
