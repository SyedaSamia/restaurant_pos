import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

class Order with ChangeNotifier {
  //String key;
  /* String orderData;
  String waiterId;
  String orderRef;
  String orderList;
  String totalPrice;
  String restaurantId;
  String orderDate;
  String date;

  bool completed;
  String userId;

  Order(this.orderDate, this.userId, this.completed);

  Order.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userId = snapshot.value["userId"],
        subject = snapshot.value["subject"],
        completed = snapshot.value["completed"];

  toJson() {
    return {
      "order_data": orderData,
      "waiter_id": waiterId,
      "order_ref": orderRef,
      "order_list": orderList,
      "total_price": totalPrice,
      "restaurant_id": restaurantId,
      "order_date": orderDate,
      "date": date
    };
  }*/

//orders.map((e) => null)
  /*Future<void> updateCheckoutOrderToServer(List orders) async {
    Auth auth = Auth();
    final waiterId = auth.userId;
    // List<CheckoutItemProvider> orderItems;
    final url = 'https://posrestaurant-simchang.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: orders.map((e) {
          json.encode({
            "waiter_id": waiterId,
            // "order_ref": orderRef,
            "order_list": e.products
                .map((cp) => {
                      'title': '${cp.title}',
                      'quantity': '${cp.quantity}',
                      'price': '${cp.price}',
                    })
                .toList(),
            //e.products.map((prod){}).toList(),
            "total_price": '${e.ammount}',
            "restaurant_id": '1',
            "order_date": '${e.dateTime}',
            "date": '$timestamp'
          });
        }).toList());
    notifyListeners();
  }*/
}
