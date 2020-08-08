import 'dart:convert';

import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider({
    @required this.categoryId,
    @required this.categoryDescription,
    this.categoryImage,
    this.categoryAction,
    this.createdAt,
    this.restaurant,
  });

  final String categoryId;
  final String categoryDescription;
  final String categoryImage;
  final String categoryAction;
  final DateTime createdAt;
  final Restaurant restaurant;

  factory CategoryProvider.fromRawJson(String str) =>
      CategoryProvider.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryProvider.fromJson(Map<String, dynamic> json) =>
      CategoryProvider(
        categoryId: json["category_id"] == null ? null : json["category_id"],
        categoryDescription: json["category_description"] == null
            ? null
            : json["category_description"],
        categoryImage:
            json["category_image"] == null ? null : json["category_image"],
        categoryAction:
            json["category_action"] == null ? null : json["category_action"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId == null ? null : categoryId,
        "category_description":
            categoryDescription == null ? null : categoryDescription,
        "category_image": categoryImage == null ? null : categoryImage,
        "category_action": categoryAction == null ? null : categoryAction,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "restaurant": restaurant == null ? null : restaurant.toJson(),
      };
}

class Restaurant {
  Restaurant({
    @required this.restaurantId,
    @required this.restaurantName,
    this.restaurantNumber,
    this.userId,
    this.restaurantStatus,
    this.createdAt,
  });

  final String restaurantId;
  final String restaurantName;
  final String restaurantNumber;
  final String userId;
  final String restaurantStatus;
  final DateTime createdAt;

  factory Restaurant.fromRawJson(String str) =>
      Restaurant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        restaurantId:
            json["restaurant_id"] == null ? null : json["restaurant_id"],
        restaurantName:
            json["restaurant_name"] == null ? null : json["restaurant_name"],
        restaurantNumber: json["restaurant_number"] == null
            ? null
            : json["restaurant_number"],
        userId: json["user_id"] == null ? null : json["user_id"],
        restaurantStatus: json["restaurant_status"] == null
            ? null
            : json["restaurant_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "restaurant_id": restaurantId == null ? null : restaurantId,
        "restaurant_name": restaurantName == null ? null : restaurantName,
        "restaurant_number": restaurantNumber == null ? null : restaurantNumber,
        "user_id": userId == null ? null : userId,
        "restaurant_status": restaurantStatus == null ? null : restaurantStatus,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
      };
}
