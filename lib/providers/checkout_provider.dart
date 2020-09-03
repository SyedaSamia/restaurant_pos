import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:restaurantpos/helpers/db_helper.dart';
import 'package:restaurantpos/models/order.dart';
import 'cart_provider.dart';

//Checkout + Order

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
  List<OrderModel> _orders = [];

  final String authToken;
  final String userId;

  CheckoutProvider(this.authToken, this.userId, this._orders);

  List<OrderModel> get orders {
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

  //inserting selected stagingOrders into order table
  Future<void> addCheckoutOrder(
      String stagingOrderId, double total, double vat) async {
    //retrieving data from staging_order table with id
    final dataList =
    await DBHelper.getDataWithId('staging_orders', stagingOrderId, 'id');
    print('printing datalist from checkout ${dataList.toList()}');
    var newFormat = DateFormat("dd-MM-yyyy hh:mm a");

    //inserting retrieved data to order table
    DBHelper.insert('orders', {
      'order_ref': stagingOrderId,
      'waiter_id': userId,
      'restaurant_id': '1',
      'total_amount': total,
      'order_date': newFormat.format(DateTime.now()).toString(), //only datevat
    });

    //retrieving data from staging_items table with id
    final dataListItems =
    await DBHelper.queryStagingOrderItem(stagingOrderId, 'staging_items');

    //inserting retrieved data to order_items table
    for (int i = 0; i < dataListItems.length; i++) {
      DBHelper.insert('order_items', {
        'id': stagingOrderId,
        'item_id': dataListItems[i].itemId,
        'title': dataListItems[i].title,
        'quantity': dataListItems[i].quantity,
        'price': dataListItems[i].price
      });
    }

    //after inserting data from staging tables into orders tables, deleting that staging order from staging tables
    DBHelper.removeRow('staging_orders', stagingOrderId, 'id');
    DBHelper.removeRow('staging_items', stagingOrderId, 'id');
  }

  Future<void> fetchOrders() async {
    _orders = [];
    final dataList = await DBHelper.getData('orders');
    print('hello fetchOrders $dataList');
    for (int i = 0; i < dataList.length; i++) {
      String _id = dataList[i]['order_ref'];
      // print(_id);
      var prod = await DBHelper.queryStagingOrderItem(_id, 'order_items');
      print(prod);
      _orders.add(OrderModel(
          orderRef: _id,
          waiterId: dataList[i]['waiter_id'],
          restaurantId: '1',
          totalAmount: dataList[i]['total_amount'],
          products: prod,
          orderDate: dataList[i]['order_date'],
          vat: dataList[i]['vat']));
    }
    notifyListeners();
  }

  Future<void> updateCheckoutOrderToServer(String _userId) async {
    // List<CheckoutItemProvider> orderItems;
    var newFormat = DateFormat("dd-MM-yyyy hh:mm a");
    try {
      final url = 'https://posrestaurant-simchang.firebaseio.com/orders.json';

      //final timestamp = DateTime.now();
      _orders.map((e) {
        http.post(url,
            body: json.encode({
              "waiter_id": '$_userId',
              "order_ref": '${e.orderRef}',
              "order_list": e.products
                  .map((cp) => {
                'title': '${cp.title}',
                'quantity': '${cp.quantity}',
                'price': '${cp.price}',
              })
                  .toList(),
              "total_price": '${e.totalAmount}',
              "restaurant_id": '1',
              "order_date": '${e.orderDate}',
              'update_date': newFormat.format(DateTime.now()).toString(),
              "vat": '${e.vat}'
            }));
      }).toList();
      _orders.clear();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
