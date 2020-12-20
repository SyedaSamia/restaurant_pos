import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../helpers/db_helper.dart';
import '../helpers/db_helper.dart';
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

  double _totalAmountToPrint;
  double get totalAmountToPrint {
    return _totalAmountToPrint;
  }

  double _currentDiscountAmount;
  bool _discountPercentage;

  double _currentDiscountToPrint;

  double get currentDiscountToPrint {
    print('current Discount amount after editing $_currentDiscountAmount');
    return _currentDiscountToPrint;
  }

  double get currentDiscountAmount {
    print('current Discount amount after editing $_currentDiscountAmount');
    return _currentDiscountAmount;
  }

  bool get discountPercentageOn {
    return _discountPercentage;
  }

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

    var disPercentage;
    double dis;
    _currentCheckoutOrdersCount = dataList.length;
    _totalCheckoutAmount = double.parse(dataList[0]['total_amount']);
    _totalCheckoutVat = double.parse(dataList[0]['vat']);
    disPercentage = dataList[0]['discount_percentage'];
    dis = double.parse(dataList[0]['discount']);
    print(
        'before total $_totalCheckoutAmount vat $_totalCheckoutVat currentDiscountToPrint $_currentDiscountToPrint');
    if (disPercentage == 1) {
      var fix = ((dis / 100) * _totalCheckoutAmount).toStringAsFixed(2);
      _currentDiscountToPrint = double.parse(fix);
      /* _currentDiscountToPrint =
          _currentDiscountToPrint.toStringAsFixed(2) as double;*/
    } else
      _currentDiscountToPrint = dis;
    print(
        'after total $_totalCheckoutAmount vat $_totalCheckoutVat currentDiscountToPrint $_currentDiscountToPrint');
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
    _totalAmountToPrint =
        _totalCheckoutAmount + _totalCheckoutVat - _currentDiscountToPrint;
    notifyListeners();
    print('current checkout items count $_currentCheckoutItemsCount  ');
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

  Future<void> addStagingOrderFromCart(
      List<CartItemProvider> cartItems,
      double total,
      double vat,
      double discount,
      bool percentageOn,
      String cartId) async {
    var _discount = 0.0;
    var _vat = 0.0;
    //if discount percentage == true
    if (percentageOn == true) {
      _discount = (discount / 100) * total;
      print(
          'total = $total discount = $discount afterDiscount = ${total - _discount}');
    } else
      _discount = discount;

    if (vat > 0) {
      var fix = (((total - _discount) * 15) / 100).toStringAsFixed(2);
      _vat = double.parse(fix);
    }

    bool _isContain =
        await DBHelper.checkIdContainsInTable('staging_orders', cartId, 'id');
    print('false = not contain, true = contains > $_isContain ');
    if (_isContain == false) {
      var newFormat = DateFormat("yy-MM-dd");

      DBHelper.insert('staging_orders', {
        'id': cartId,
        'total_amount': total,
        'date_time': newFormat.format(DateTime.now()).toString(), //only date
        'vat': _vat,
        'discount': discount,
        'discount_percentage': percentageOn == false ? 0 : 1
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
        'vat': _vat,
        'discount': discount,
        'discount_percentage': percentageOn == false ? 0 : 1
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
    var total, percentage, discount, vat;
    for (int i = 0; i < dataList.length; i++) {
      String _id = dataList[i]['id'];
      total = double.parse(dataList[i]['total_amount']);
      vat = double.parse(dataList[i]['vat']);
      discount = double.parse(dataList[i]['discount']);
      print(_id);
      if (dataList[i]['discount_percentage'] == 1)
        discount = (discount / 100) * total;
      total = total + vat - discount;
      _stagingOrders.add(OrderStagingItemProvider(
          id: _id,
          amount: total,
          dateTime: dataList[i]['date_time'],
          products: await DBHelper.queryStagingOrderItem(_id, 'staging_items'),
          vat: vat));
    }
    print('fetch&stagedOrders $_stagingOrders');
    notifyListeners();
    print('editStagingOrder function in order_staging_provider ends');
  }

  //shows selected staging orders in cart
  Future<void> editStagingOrder(String _id) async {
    print('editStagingOrder function in order_staging_provider starts');
    bool _isContain =
        await DBHelper.checkIdContainsInTable('cart_items', _id, 'itemId');
    print('false = not contain, true = contains > $_isContain ');

    var _resultDiscount;
    var _resultPercentageBool;

    if (_isContain == true) {
      DBHelper.removeAllRows('cart_items');
    }

    var _list = await DBHelper.queryStagingOrderItem(_id, 'staging_items');
    //  print('staging_items = $_list');

    //update discount starts
    print('update discount in editStagingOrder function starts');
    _resultDiscount = await DBHelper.getDataWithId('staging_orders', _id, 'id');
    _resultPercentageBool =
        await DBHelper.getDataWithId('staging_orders', _id, 'id');

    var fix = (_resultDiscount[0]['discount']);
    print('edit staging order > fix $fix');
    _currentDiscountAmount = double.parse(fix);
    _discountPercentage =
        _resultPercentageBool[0]['discount_percentage'] == 0 ? false : true;

    print('update discount in editStagingOrder function ends');
    //update discount ends

    for (int i = 0; i < _list.length; i++) {
      DBHelper.insert('cart_items', {
        'itemId': _list[i].itemId,
        'id': _list[i].id,
        'title': _list[i].title, //only date
        'quantity': _list[i].quantity,
        'price': _list[i].price
      });
    }

    notifyListeners();
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
