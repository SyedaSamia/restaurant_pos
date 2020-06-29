import 'package:flutter/foundation.dart';

class ItemProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  ItemProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
  });
}
