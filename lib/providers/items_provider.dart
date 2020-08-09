import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/item_provider.dart';

/*
* Gets items from server with api calling
*
*
* */

class ItemsProvider with ChangeNotifier {
  List<ItemProvider> _items = [];

  final String userId;

  ItemsProvider(this.userId, this._items);

  List<ItemProvider> get items {
    return [..._items];
  }

  ItemProvider findById(String id) {
    return _items.firstWhere((prod) => prod.itemId == id);
  }

  Future<void> fetchAndSetItems() async {
    final url = 'http://haalkhata.xyz/api/items';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List _list = extractedData['response'];
      if (_list == null) {
        return;
      }
      final List<ItemProvider> loadedProducts = [];
      for (int i = 0; i < _list.length; i++) {
        loadedProducts.add(ItemProvider(
            itemId: _list[i]['item_id'],
            title: _list[i]['description'],
            price: _list[i]['price']));
        /*print(
            'item_id: ${_list[i]['item_id']}\ntitle: ${_list[i]['description']}\nprice: ${_list[i]['price']}');*/
        print(loadedProducts[0].title);
      }

      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
