import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:point_of_sale6/helpers/db_helper.dart';
import 'package:point_of_sale6/helpers/db_provider.dart';
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
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a network.

      final url = 'http://haalkhata.xyz/api/items';
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final extractedData =
              json.decode(response.body) as Map<String, dynamic>;
          List _list = extractedData['response'];

          final List<ItemProvider> loadedProducts = [];
          for (int i = 0; i < _list.length; i++) {
            loadedProducts.add(ItemProvider(
                itemId: _list[i]['item_id'],
                title: _list[i]['description'],
                price: _list[i]['price']));

            DBHelper.insert('items', {
              'item_id': _list[i]['item_id'],
              'item_title': _list[i]['description'],
              'price': _list[i]['price']
            });
          }
          final dataList = await DBHelper.getData('items');
          //print('datalist $dataList');
          _items = loadedProducts;
          notifyListeners();
        } else {
          return;
        }
      } catch (error) {
        throw (error);
      }
    } else {
      // I am not connected to the internet
      final dataList = await DBHelper.getData('items');
      print(dataList);
      for (int i = 0; i < dataList.length; i++) {
        _items[i] = ItemProvider(
            itemId: dataList[i]['item_id'],
            title: dataList[i]['item_title'],
            price: dataList[i]['price']);
      }
      notifyListeners();
    }
  }
}
