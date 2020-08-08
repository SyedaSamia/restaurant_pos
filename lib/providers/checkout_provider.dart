import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'auth.dart';
import 'cart_provider.dart';

class CheckoutItemProvider {
  final String id;
  final double amount;
  final List<CartItemProvider> products;
  final DateTime dateTime;
  final double vat;

  CheckoutItemProvider(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime,
      @required this.vat});
}

class CheckoutProvider with ChangeNotifier {
  List<CheckoutItemProvider> _orders = [];

  final String authToken;
  final String userId;

  CheckoutProvider(this.authToken, this.userId, this._orders);

  List<CheckoutItemProvider> get orders {
    /*if (_orders.length == 1 && _orders[0].amount == 00)
      return null;
    else*/
    return [..._orders];
  }

  bool get checkNullOrder {
    if (_orders.length > 0)
      return false;
    else
      return true;
  }

  /*Future<void> fetchAndSetCheckoutOrders() async {
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
  }*/
  var timestamp;
  void addCheckoutOrder(
      List<CartItemProvider> cartProducts, double total, double vat) {
    timestamp = DateTime.now();
    _orders.insert(
      0,
      CheckoutItemProvider(
          id: timestamp.toString(),
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
          vat: vat),
    );
    notifyListeners();
  }

  Future<void> updateCheckoutOrderToServer(String _userId) async {
    // List<CheckoutItemProvider> orderItems;
    try {
      final url = 'https://posrestaurant-simchang.firebaseio.com/orders.json';
      final timestamp = DateTime.now();
      _orders.map((e) {
        http.post(url,
            body: json.encode({
              "waiter_id": '$_userId',
              // "order_ref": orderRef,
              "order_list": e.products
                  .map((cp) => {
                        'title': '${cp.title}',
                        'quantity': '${cp.quantity}',
                        'price': '${cp.price}',
                      })
                  .toList(),
              "total_price": '${e.amount}',
              "restaurant_id": '1',
              "order_date": '${e.dateTime}',
              "date": '${timestamp.toIso8601String()},'
            }));
      }).toList();
      _orders.clear();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  /* Future<void> updateCheckoutOrderToServer() async {
    // List<CheckoutItemProvider> orderItems;
    final url =
        'https://posrestaurant-simchang.firebaseio.com/orders.json?auth=$authToken';
    //final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'order_id': _orders.
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
          'total': c
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
*/
  /*Future<void> addCheckoutOrder(
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
  }*/
}
