import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:restaurantpos/helpers/db_helper.dart';
import 'package:restaurantpos/models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesProvider with ChangeNotifier {
  List<CategoryProvider> _category = [];

  final String userId;

  // ItemsProvider(this.authToken, this.userId, this._items);
  CategoriesProvider(this.userId, this._category);

  List<CategoryProvider> get categories {
    return [..._category];
  }

  CategoryProvider findById(String id) {
    return _category.firstWhere((prod) => prod.categoryId == id);
  }

  Future<void> fetchAndSetItems() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        print('>> try autologin false');
        return false;
      }
      final extractedUserData =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      final _rid = extractedUserData['restaurant_id'];

      final url =
          'http://haalkhata.xyz/api/item_categories_by_restaurant?restaurant_id=$_rid';
      try {
        final response = await http.get(url);
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        var _list = extractedData['response'];
        if (response.statusCode == 200) {
          List<CategoryProvider> loadedProducts = [];
          for (int i = 0; i < _list.length; i++) {
            loadedProducts.add(CategoryProvider(
              categoryId: _list[i]['category_id'],
              categoryDescription: _list[i]['category_description'],
              categoryImage: _list[i]['category_image'],
            ));
            DBHelper.insert('categories', {
              'category_id': _list[i]['category_id'],
              'category_description': _list[i]['category_description'],
              'price': _list[i]['category_image']
            });
          }
          final dataList = await DBHelper.getData('categories');
          print('datalist $dataList');
          _category = loadedProducts;
          notifyListeners();
        } else {
          return;
        }
      } catch (error) {
        throw (error);
      }
    } else {
      final dataList = await DBHelper.getData('categories');
      print(dataList);
      for (int i = 0; i < dataList.length; i++) {
        _category[i] = CategoryProvider(
            categoryId: dataList[i]['item_id'],
            categoryDescription: dataList[i]['item_title'],
            categoryImage: dataList[i]['price']);
      }
      notifyListeners();
    }
  }
}
