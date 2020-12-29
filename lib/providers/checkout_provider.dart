import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:restaurantpos/helpers/db_helper.dart';
import 'package:restaurantpos/models/order.dart';
import 'package:restaurantpos/providers/order_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_provider.dart';

//Checkout + Order

class CheckoutItemProvider {
  final String id;
  final double amount;
  final List<CartItemProvider> products;
  final DateTime dateTime;
  final double vat;
  var res;

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
      String stagingOrderId, double total, double vat, double discount) async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final _rid = extractedUserData['restaurant_id'];

    //retrieving data from staging_order table with id
    final dataList =
        await DBHelper.getDataWithId('staging_orders', stagingOrderId, 'id');
    print('printing datalist from checkout ${dataList.toList()}');
    var newFormat = DateFormat("dd-MM-yyyy hh:mm a");

    //inserting retrieved data to order table
    DBHelper.insert('orders', {
      'order_ref': stagingOrderId,
      'waiter_id': userId,
      'restaurant_id': '$_rid',
      'total_amount': total,
      'vat': '$vat',
      'discount': '$discount',
      'order_date': newFormat.format(DateTime.now()).toString(), //only datevat
    });

    //retrieving data from staging_items table with id
    final dataListItems =
        await DBHelper.queryStagingOrderItem(stagingOrderId, 'staging_items');

    //inserting retrieved data to order_items table
    for (int i = 0; i < dataListItems.length; i++) {
      String _xitemId = '${dataListItems[i].itemId}';
      print('item id in add checkout=> $_xitemId');
      await DBHelper.insert('order_items', {
        'itemId': _xitemId,
        'id': stagingOrderId,
        'title': dataListItems[i].title,
        'quantity': dataListItems[i].quantity.toString(),
        'price': dataListItems[i].price.toString()
      });
      print('item id in add checkout after=> ${dataListItems[i].itemId}');
    }
    var prod =
        await DBHelper.queryStagingOrderItem(stagingOrderId, 'order_items');
    print(
        'item id checking in add checkout order orderitems ${prod[0].itemId} ${prod[0].title} ${dataListItems[0].itemId}');

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
      print(prod[0].itemId);
      print(prod);
      _orders.add(OrderModel(
          orderRef: _id,
          waiterId: dataList[i]['waiter_id'],
          restaurantId: dataList[i]['restaurant_id'],
          totalAmount: dataList[i]['total_amount'],
          products: prod,
          orderDate: dataList[i]['order_date'],
          vat: dataList[i]['vat'],
          discount: dataList[i]['discount']));
    }
    notifyListeners();
  }

  Future<void> updateCheckoutOrderToServer(String _userId) async {
    // List<CheckoutItemProvider> orderItems;
    //var newFormat = DateFormat("dd-MM-yyyy hh:mm a");

    _orders.map((e) async {
      var dateTime = DateTime.now();
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'POST', Uri.parse('http://haalkhata.xyz/api/submit_order'));
      print('userId: $_userId, vat = ${e.vat}, discount = ${e.discount}');
      print('${e.products.map((cp) => {
            'item_id': "${cp.itemId}",
            'item_description': "${cp.title}",
            'quantity': cp.quantity,
            'price': cp.price,
          }).toList()}');

      /*   List<ItemDetails> oItems = e.products
          .map((cp) => ItemDetails(
              cp.itemId, cp.title, cp.quantity.toString(), cp.price.toString()))
          .toList();*/

      List<Map<String, Object>> oItems = e.products
          .map((cp) => {
                'item_id': "${cp.itemId}",
                'item_description': "${cp.title}",
                'quantity': cp.quantity,
                'price': cp.price,
              })
          .toList();

      print(oItems);

      request.bodyFields = {
        'waiter_id': '$_userId',
        'order_ref': '$dateTime',
        'order_list': json.encoder.convert(oItems),
        'total_price': '${e.totalAmount}',
        'restaurant_id': '${e.restaurantId}',
        'discount_amount': '${e.discount}',
        'vat': e.vat == null ? '0.0' : '${e.vat}',
        'discount_code': '',
        'order_date': '${e.orderDate}'
      };
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }).toList();
    _orders.clear();
    DBHelper.removeAllRows('orders');
    DBHelper.removeAllRows('order_items');
    notifyListeners();
  }
}
