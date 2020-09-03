import 'package:flutter/foundation.dart';
import 'package:restaurantpos/helpers/db_helper.dart';

class CartItemProvider {
  final String id; //cart_id
  final String itemId;
  final String title;
  final int quantity;
  final double price;

  CartItemProvider({
    @required this.id,
    @required this.itemId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItemProvider> _items = {};

  Map<String, CartItemProvider> get items {
    return {..._items};
  }

  String _carrStagedOrderId = '';

  void takeCurrentStagedOrderId(String _id) {
    _carrStagedOrderId = _id;
  }

  String get carrStagedOrderId {
    return _carrStagedOrderId;
  }

  int get itemCount {
    var itemCount = 0;
    if (_items != null) {
      _items.forEach((key, value) {
        print('value.quantity = ${value.quantity}');
        itemCount += value.quantity;
        // itemCount = 1 + value.quantity;
      });
    }
    //  print('hello from itemCCount = $itemCount');
    return itemCount;
  }

  double get totalVat {
    if (checkVat == true) {
      var total = 0.0;
      _items.forEach((key, cartItem) {
        total += cartItem.price * cartItem.quantity;
      });
      var vat = total * 0.15;
      return vat;
    } else
      return 0.00;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    if (checkVat == true) {
      var vat = totalVat;
      return total + vat;
    } else
      return total;
  }

  var _checkVat = false;

  void changeCheckVat(bool _check) {
    _checkVat = _check;
    notifyListeners();
  }

  bool get checkVat {
    return _checkVat;
  }

  Future<void> addItem(String productId, double price, String title) async {
    //storing into mbl database
    var _checkEmptyTable = await DBHelper.checkEmptyTable('cart_items');
    print('_checkEmptyTable = $_checkEmptyTable');
    //true = empty, false = not empty
    if (_checkEmptyTable == true) {
      print('empty cart_items table ');
      DBHelper.insert('cart_items', {
        'itemId': productId,
        'id': DateTime.now().toString(),
        'title': title, //only date
        'quantity': 1,
        'price': price
      });
    } else {
      print('Not empty cart_items table ');
      var _dateTime = await DBHelper.getCartItemsId('cart_items');
      var _isNotEmpty = await DBHelper.checkIdContainsInTable(
          'cart_items', productId, 'itemId');
      if (_isNotEmpty == false) {
        DBHelper.insert('cart_items', {
          'itemId': productId,
          'id': _dateTime,
          'title': title, //only date
          'quantity': 1,
          'price': price
        });
      } else {
        int qty = await DBHelper.queryQuantityFromCart(
            'cart_items', productId, 'itemId');
        print('qty from add items in cart provider = $qty');
        DBHelper.updateCartItemQnty('cart_items', qty + 1, productId, 'itemId');
      }
    }
  }

  Future<void> addItemToEdit(
      String productId, double price, String title) async {
    final bool _isNotEmpty = await DBHelper.checkIdContainsInTable(
        'cart_items', productId, 'itemId');
    if (!_isNotEmpty) {
      DBHelper.insert('cart_items', {
        'itemId': productId,
        'id': _carrStagedOrderId,
        'title': title, //only date
        'quantity': 1,
        'price': price
      });
    } else {
      int qty = await DBHelper.queryQuantityFromCart(
          'cart_items', productId, 'itemId');
      print(qty);
      DBHelper.updateCartItemQnty('cart_items', qty + 1, productId, 'itemId');
    }
  }

  Future<void> fetchCartItem() async {
    final dataList = await DBHelper.getData('cart_items');
    print('dataList $dataList');
    for (int i = 0; i < dataList.length; i++) {
      var prodId = dataList[i]['itemId'];
      int qty =
          await DBHelper.queryQuantityFromCart('cart_items', prodId, 'itemId');
      print(
          'qty in fetchcartitem ${dataList[i]['title']} ${dataList[i]['id']} $qty');
      if (_items.containsKey(dataList[i]['itemId'])) {
        print('update in fetchcartItem');
        _items.update(
          prodId,
          (existingCartItem) => CartItemProvider(
            id: existingCartItem.id,
            itemId: prodId,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: qty,
          ),
        );
      } else {
        //ekhane problem.. _item e id ta pacchena
        print('put if absent in fetchcartItem ${items.toString()}');
        _items.putIfAbsent(
            prodId,
            () => CartItemProvider(
                  id: dataList[i]['id'],
                  itemId: prodId,
                  title: dataList[i]['title'],
                  price: double.parse(dataList[i]['price']),
                  quantity: qty,
                ));
      }
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    DBHelper.removeRow('cart_items', productId, 'itemId')
        .then((value) => _items.remove(productId));
    fetchCartItem();
    notifyListeners();
  }

  Future<void> removeSingleItem(String productId) async {
    /*if (!_items.containsKey(productId)) {
      return;
    }*/
    int qty =
        await DBHelper.queryQuantityFromCart('cart_items', productId, 'itemId');
    print('qty from removeSingleItem = $qty');
    if (qty > 1) {
      DBHelper.updateCartItemQnty('cart_items', qty - 1, productId, 'itemId');
      _items.update(
        productId,
        (existingCartItem) => CartItemProvider(
          id: existingCartItem.id,
          itemId: productId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      DBHelper.removeRow('cart_items', productId, 'itemId');
      _items.remove(productId);
    }
    // fetchCartItem();
    notifyListeners();
  }

  Future<void> addSingleItem(String productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    int qty =
        await DBHelper.queryQuantityFromCart('cart_items', productId, 'itemId');
    DBHelper.updateCartItemQnty('cart_items', qty + 1, productId, 'itemId');
    //fetchCartItem();
    _items.update(
      productId,
      (existingCartItem) => CartItemProvider(
        id: existingCartItem.id,
        itemId: productId,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1,
      ),
    );
    notifyListeners();
  }

  //after checkout cart will be empty again
  void clear() {
    DBHelper.removeAllRows('cart_items').then((value) => _items = {});
    notifyListeners();
  }
}
