import 'package:flutter/cupertino.dart';
import 'package:restaurantpos/providers/cart_provider.dart';
import 'package:restaurantpos/providers/checkout_provider.dart';

class OrderStagingItemProvider {
  final String id;
  final double amount;
  final List<CartItemProvider> products;
  final DateTime dateTime;
  final double vat;

  OrderStagingItemProvider(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime,
      @required this.vat});
}

class OrderStagingProvider with ChangeNotifier {
  List<OrderStagingItemProvider> _stagingOrders = [];
  final String authToken;
  final String userId;

  OrderStagingProvider(this.authToken, this.userId, this._stagingOrders);
  List<OrderStagingItemProvider> get stagingOrders {
    //  print(_stagingOrders.length);
    return [..._stagingOrders];
  }

  /* int get stagingOrderId(int id){
    return
  }
*/

  void deleteOrder() {
    _stagingOrders
        .removeWhere((element) => element.id == _idToDeleteStagingOrder);
    notifyListeners();
  }

  /*OrderStagingItemProvider findOrder(String id) {
    return _stagingOrders.firstWhere((element) => element.id == id);
  }*/
  String _idToDeleteStagingOrder;

  /* void idToDeleteStagingOrder(){
    _idToDeleteStagingOrder = id;
    notifyListeners();
  }*/

  void findOrder(String id) {
    _idToDeleteStagingOrder = id;
    _checkoutItem =
        _stagingOrders.firstWhere((element) => element.id == id).products;
    /* for (int i = 0; i < _checkoutItem.length; i++) {
      print('here is :');
      print(_checkoutItem[i].title);
      print(_checkoutItem[i].price);
      print(_checkoutItem[i].quantity);
    }*/
    notifyListeners();
  }

  bool get checkNullStagingOrder {
    if (_stagingOrders.length > 0)
      return false;
    else
      return true;
  }

  void addStagingOrderFromCart(
      List<CartItemProvider> cartItems, double total, double vat) {
    var timestamp = DateTime.now();
    _stagingOrders.insert(
      0,
      OrderStagingItemProvider(
          id: timestamp.toString(),
          amount: total,
          dateTime: DateTime.now(),
          products: cartItems,
          vat: vat),
    );
    notifyListeners();
  }

  /*Map<String, CartItemProvider> _checkoutItem = {};
  Map<String, CartItemProvider> get checkoutItem {
    return {..._checkoutItem};
  }*/

  List<CartItemProvider> _checkoutItem = [];
  List<CartItemProvider> get checkoutItem {
    return [..._checkoutItem];
  }

  /* showCheckoutItems(Map orderStagingItemProvider) {
    _checkoutItem = orderStagingItemProvider;
  }*/

  double get totalCheckoutVat {
    var total = 0.0;
    _checkoutItem.forEach((cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    var vat = total * 0.15;
    return vat;
  }

  double get totalCheckoutAmount {
    var total = 0.0;
    _checkoutItem.forEach((cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    var vat = totalCheckoutVat;
    return total + vat;
  }

  void clear() {
    _checkoutItem = [];
    notifyListeners();
  }
}
