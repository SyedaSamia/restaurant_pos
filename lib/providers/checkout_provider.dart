import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  final String authToken;
  final String userId;

  CheckoutProvider(this.authToken, this.userId, this._orders);

  List<CheckoutItemProvider> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetCheckoutOrders() async {
    final url =
        'https://posrestaurant-simchang.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(url);
    final List<CheckoutItemProvider> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        CheckoutItemProvider(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItemProvider(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  /*void addCheckoutOrder(List<CartItemProvider> cartProducts, double total) {
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
  }*/

  Future<void> addCheckoutOrder(
      List<CartItemProvider> cartProducts, double total) async {
    final url =
        'https://posrestaurant-simchang.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      CheckoutItemProvider(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
