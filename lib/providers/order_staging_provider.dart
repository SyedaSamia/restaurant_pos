import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale6/helpers/db_helper.dart';
import 'cart_provider.dart';

class OrderStagingItemProvider {
  final String id;
  final double amount;
  final List<CartItemProvider> products;
  final String dateTime;
  final double vat;

  OrderStagingItemProvider(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime,
      @required this.vat});

  Map<String, dynamic> toMap() {
    return {'id': id, 'amount': amount, 'vat': vat, 'dateTime': dateTime};
  }
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

  int get stagingOrderLength {
    return _stagingOrders.length;
  }

  String _currentOrderId;

  String get currentOrderId {
    return _currentOrderId;
  }

  double _totalCheckoutAmount;
  double _totalCheckoutVat;
  int _currentCheckoutItemsCount;
  int _currentCheckoutOrdersCount;

  int get currentCheckoutItemsCount {
    return _currentCheckoutItemsCount;
  }

  int get currentCheckoutOrdersCount {
    //print('_currentCheckoutOrdersCount = $_currentCheckoutItemsCount');
    return _currentCheckoutOrdersCount;
  }

  Future<void> findOrder(String id) async {
    _currentOrderId = id;
    final dataList =
        await DBHelper.getDataWithId('staging_orders', _currentOrderId, 'id');
    /*  print(
        'length of datalist after pressing checkout: length ${dataList.length} id: ${dataList[0]['id']}');*/
    _currentCheckoutOrdersCount = dataList.length;
    _totalCheckoutAmount = double.parse(dataList[0]['total_amount']);
    _totalCheckoutVat = double.parse(dataList[0]['vat']);

    final dataListItems =
        await DBHelper.queryStagingOrderItem(id, 'staging_items');
    _currentCheckoutItemsCount = dataListItems.length;
    for (int i = 0; i < _currentCheckoutItemsCount; i++) {
      print(
          'current checkout items count $_currentCheckoutItemsCount = ${dataListItems[i].title}');
      _checkoutItem.add(CartItemProvider(
          id: dataListItems[i].id,
          itemId: dataListItems[i].itemId,
          title: dataListItems[i].title,
          quantity: dataListItems[i].quantity,
          price: dataListItems[i].price));
    }

    notifyListeners();
    print('current checkout items count $_currentCheckoutItemsCount ');
  }

  Future<void> deleteStagingOrder(String id) async {
    DBHelper.removeRow('staging_orders', id, 'id');
    DBHelper.removeRow('staging_items', id, 'id');
  }

  bool get checkNullStagingOrder {
    if (_stagingOrders.length > 0)
      return false;
    else
      return true;
  }

  Future<void> addStagingOrderFromCart(List<CartItemProvider> cartItems,
      double total, double vat, String cartId) async {
    bool _isContain =
        await DBHelper.checkIdContainsInTable('staging_orders', cartId, 'id');
    print('false = not contain, true = contains > $_isContain ');
    if (_isContain == false) {
      var newFormat = DateFormat("yy-MM-dd");

      DBHelper.insert('staging_orders', {
        'id': cartId,
        'total_amount': total,
        'date_time': newFormat.format(DateTime.now()).toString(), //only date
        'vat': vat
      });
      print('putting into id $cartId');

      for (int i = 0; i < cartItems.length; i++) {
        DBHelper.insert('staging_items', {
          'id': cartId,
          'itemId': cartItems[i].itemId,
          'title': cartItems[i].title,
          'quantity': cartItems[i].quantity,
          'price': cartItems[i].price
        });
      }
    } else {
      DBHelper.removeRow('staging_orders', cartId, 'id');
      DBHelper.removeRow('staging_items', cartId, 'id');

      var newFormat = DateFormat("yy-MM-dd");

      DBHelper.insert('staging_orders', {
        'id': cartId,
        'total_amount': total,
        'date_time': newFormat.format(DateTime.now()).toString(), //only date
        'vat': vat
      });
      print('putting into id $cartId');

      for (int i = 0; i < cartItems.length; i++) {
        DBHelper.insert('staging_items', {
          'id': cartId,
          'itemId': cartItems[i].itemId,
          'title': cartItems[i].title,
          'quantity': cartItems[i].quantity,
          'price': cartItems[i].price
        });
      }
    }
  }

  Future<void> fetchAndSetStagedOrders() async {
    _stagingOrders = [];
    final dataList = await DBHelper.getData('staging_orders');
    for (int i = 0; i < dataList.length; i++) {
      String _id = dataList[i]['id'];
      print(_id);
      _stagingOrders.add(OrderStagingItemProvider(
          id: _id,
          amount: double.parse(dataList[i]['total_amount']),
          dateTime: dataList[i]['date_time'],
          products: await DBHelper.queryStagingOrderItem(_id, 'staging_items'),
          vat: double.parse(dataList[i]['vat'])));
    }
    print('fetch&stagedOrders $_stagingOrders');
    notifyListeners();
  }

  //shows selected staging orders in cart
  Future<void> editStagingOrder(String _id) async {
    bool _isContain =
        await DBHelper.checkIdContainsInTable('cart_items', _id, 'itemId');
    print('false = not contain, true = contains > $_isContain ');
    if (_isContain == true) {
      DBHelper.removeAllRows('cart_items');
      var _list = await DBHelper.queryStagingOrderItem(_id, 'staging_items');
      //  print('staging_items = $_list');
      for (int i = 0; i < _list.length; i++) {
        DBHelper.insert('cart_items', {
          'itemId': _list[i].itemId,
          'id': _list[i].id,
          'title': _list[i].title, //only date
          'quantity': _list[i].quantity,
          'price': _list[i].price
        });
      }
    } else {
      var _list = await DBHelper.queryStagingOrderItem(_id, 'staging_items');
      //  print('staging_items = $_list');
      for (int i = 0; i < _list.length; i++) {
        DBHelper.insert('cart_items', {
          'itemId': _list[i].itemId,
          'id': _list[i].id,
          'title': _list[i].title, //only date
          'quantity': _list[i].quantity,
          'price': _list[i].price
        });
      }
    }
  }

  List<CartItemProvider> _checkoutItem = [];
  List<CartItemProvider> get checkoutItem {
    return [..._checkoutItem];
  }

  double get totalCheckoutVat {
    /* var total = 0.0;
    _checkoutItem.forEach((cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    var vat = total * 0.15;
    return vat;*/
    return _totalCheckoutVat;
  }

  double get totalCheckoutAmount {
    /*var total = 0.0;
    _checkoutItem.forEach((cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    var vat = totalCheckoutVat;
    return total + vat;*/
    return _totalCheckoutAmount;
  }

  void deleteOrder() {
    notifyListeners();
  }

  Future<void> clear() async {
    //  DBHelper.removeRow('staging_orders', _currentOrderId, 'id');
    // DBHelper.removeRow('staging_items', _currentOrderId, 'id');
    _stagingOrders.removeWhere((element) => element.id == _currentOrderId);
    _checkoutItem = [];
    notifyListeners();
  }
}
