import 'package:flutter/material.dart';

import 'item_provider.dart';

class ItemsProvider with ChangeNotifier {
  List<ItemProvider> _items = [
    ItemProvider(
        id: 'p1',
        title: 'Korean Fried Chicken',
        description: 'Korean Fried Chicken with hot korean sauce',
        price: 300),
    ItemProvider(
        id: 'p2',
        title: 'Korean Kimchi',
        description: 'Korean Fried Chicken with hot korean sauce',
        price: 90),
    ItemProvider(
        id: 'p3',
        title: 'Japanese Fried Chicken',
        description: 'Korean Fried Chicken with hot korean sauce',
        price: 599),
    ItemProvider(
        id: 'p4',
        title: 'Chinese Fried Chicken',
        description: 'Korean Fried Chicken with hot korean sauce',
        price: 230),
    ItemProvider(
        id: 'p5',
        title: 'Korean Bulgogi',
        description: 'Korean Fried Chicken with hot korean sauce',
        price: 200),
  ];

  List<ItemProvider> get items {
    return [..._items];
  }

  ItemProvider findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addItem(ItemProvider item) {
    final newProduct = ItemProvider(
      title: item.title,
      description: item.description,
      price: item.price,
   //   imageUrl: item.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct); // at the start of the list
    notifyListeners();
  }

  void updateItem(String id, ItemProvider newItem) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newItem;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
