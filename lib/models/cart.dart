import 'dart:ffi';

import 'package:flutter/material.dart';

class Cart {
  final String id;
  final Image itemImage;
  final String itemName;
  final double itemPrice;
  final int itemQuantity;

  const Cart(
      {@required this.id,
      this.itemImage,
      @required this.itemName,
      @required this.itemPrice,
      this.itemQuantity});
}
