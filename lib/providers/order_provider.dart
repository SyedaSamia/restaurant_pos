import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:restaurantpos/providers/auth.dart';

class ItemDetails {
  String itemId;
  String itemDescription;
  String quantity;
  String price;

  ItemDetails(this.itemId, this.itemDescription, this.quantity, this.price);

  Map toJson() => {
        'item_id': itemId,
        'item_description': itemDescription,
        'quantity': quantity,
        'price': price
      };
}
