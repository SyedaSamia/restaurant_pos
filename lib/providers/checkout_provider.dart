import 'package:flutter/material.dart';

import 'cart_provider.dart';

class CheckoutItemProvider {
  final String id;
  final double amount;
  final List<CartItemProvider> products;
  final DateTime dateTime;

  CheckoutItemProvider({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class CheckoutProvider with ChangeNotifier {
  List<CheckoutItemProvider> _orders = [];

  List<CheckoutItemProvider> get orders {
    return [..._orders];
  }

  void addCheckoutOrder(List<CartItemProvider> cartProducts, double total) {
    _orders.insert(
      0,
      CheckoutItemProvider(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
