import 'package:flutter/foundation.dart';
import 'dart:convert';

List<ItemProvider> employeeFromJson(String str) => List<ItemProvider>.from(
    json.decode(str).map((x) => ItemProvider.fromJson(x)));

String employeeToJson(List<ItemProvider> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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

  factory ItemProvider.fromJson(Map<String, String> json) => ItemProvider(
        itemId: json["item_id"],
        title: json["description"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "description": title,
        "price": price,
      };
}
