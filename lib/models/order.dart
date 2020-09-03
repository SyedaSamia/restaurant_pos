import 'package:flutter/foundation.dart';
import 'package:restaurantpos/providers/cart_provider.dart';

class OrderModel {
  final String orderRef;
  final String waiterId;
  final String restaurantId;
  final String totalAmount;
  final List<CartItemProvider> products;
  final String orderDate;
  final String vat;

  OrderModel(
      {@required this.orderRef,
      @required this.waiterId,
      @required this.restaurantId,
      @required this.totalAmount,
      @required this.products,
      @required this.orderDate,
      @required this.vat});
}
