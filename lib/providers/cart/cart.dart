import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartCount {
    return _items.length;
  }

  num get totalSum {
    num totalPrice = 0;

    _items.forEach((key, value) {
      totalPrice += value.qty * value.price;
    });

    return totalPrice;
  }

  void addItemToCart(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (oldVal) => CartItem(
          id: oldVal.id,
          title: oldVal.title,
          qty: oldVal.qty + 1,
          price: oldVal.price,
        ),
      );
    } else {
      _items[productId] = CartItem(
        id: DateTime.now().toString(),
        qty: 1,
        title: title,
        price: price,
      );
    }

    notifyListeners();
  }

  void removeCartItem(String id) {
    _items.removeWhere((prodId, _) => prodId == id);
    notifyListeners();
  }

  void emptyCart() {
    _items.clear();
    notifyListeners();
  }

  void undoCart(String productId) {
    if(!_items.containsKey(productId)) {
      return;
    }

    if(_items[productId]!.qty > 1) {
      _items.update(productId, (oldValue) => CartItem(id: oldValue.id, title: oldValue.title, qty: oldValue.qty -1, price: oldValue.price));
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }
}

class CartItem {
  final String id;
  final String title;
  final int qty;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.qty,
    required this.price,
  });
}
