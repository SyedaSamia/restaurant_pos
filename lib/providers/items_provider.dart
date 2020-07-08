import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaurantpos/providers/item_model.dart';
import '../models/http_exception.dart';

class ItemsProvider with ChangeNotifier {
  List<ItemModel> _items = [
    /*   ItemProvider(
        id: 'p1',
        title: 'Korean Fried Chicken',
        category: 'Korean',
        price: 300,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg'),
    ItemProvider(
        id: 'p2',
        title: 'Korean Kimchi',
        category: 'Korean',
        price: 90,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg'),
   */
  ];
  final String authToken;
  final String userId;

  ItemsProvider(this.authToken, this.userId, this._items);

  List<ItemModel> get items {
    return [..._items];
  }

  ItemModel findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetItems() async {
    final url =
        'https://posrestaurant-simchang.firebaseio.com/items.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<ItemModel> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(ItemModel(
          id: prodId,
          title: prodData['title'],
          category: prodData['category'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          //restaurant: prodData['restaurant']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  /*void addItem(ItemProvider item) {
    final newProduct = ItemProvider(
      title: item.title,
      category: item.category,
      price: item.price,
   //   imageUrl: item.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct); // at the start of the list
    notifyListeners();
  }*/
  Future<void> addItem(ItemModel product) async {
    final url =
        'https://posrestaurant-simchang.firebaseio.com/items.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'category': product.category,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'restaurant': product.restaurant
        }),
      );
      final newProduct = ItemModel(
        title: product.title,
        category: product.category,
        price: product.price,
        imageUrl: product.imageUrl,
        // restaurant: product.restaurant,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /*void updateItem(String id, ItemProvider newItem) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newItem;
      notifyListeners();
    } else {
      print('...');
    }
  }*/
  Future<void> updateItem(String id, ItemModel newItem) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://posrestaurant-simchang.firebaseio.com/items/$id.json=auth?$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newItem.title,
            'category': newItem.category,
            'imageUrl': newItem.imageUrl,
            'price': newItem.price,
            'restaurant': newItem.restaurant
          }));
      _items[prodIndex] = newItem;
      notifyListeners();
    } else {
      print('...');
    }
  }

  /*void deleteItem(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }*/

  Future<void> deleteItem(String id) async {
    final url =
        'https://posrestaurant-simchang.firebaseio.com/items/$id.json=auth?$authToken';
    final existingItemIndex = _items.indexWhere((prod) => prod.id == id);
    var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingItem = null;
  }
}
