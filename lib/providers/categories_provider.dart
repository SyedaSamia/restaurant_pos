import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:restaurantpos/models/category.dart';

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
    final url = 'http://haalkhata.xyz/api/item_categories';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      var _list = extractedData['response'];
      if (_list == null) {
        return;
      }
      List<CategoryProvider> loadedProducts = [];
      for (int i = 0; i < _list.length; i++) {
        loadedProducts.add(CategoryProvider(
          categoryId: _list[i]['category_id'],
          categoryDescription: _list[i]['category_description'],
          categoryImage: _list[i]['category_image'],
        ));
      }

      _category = loadedProducts;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
