import 'package:flutter/foundation.dart';

class CartItemProvider {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItemProvider({
    @required this.id,
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

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...
      _items.update(
        productId,
        (existingCartItem) => CartItemProvider(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItemProvider(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItemProvider(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  //after checkout cart will be empty again
  void clear() {
    _items = {};
    notifyListeners();
  }
}
