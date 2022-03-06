import 'package:flutter/foundation.dart';

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {
    'p1': CartItem(id: 'c1', title: 'product one', qty: 1, price: 2.3),
  };

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItemToCart(String productId, String title, double price, int qty) {
    if(_items.containsKey(productId)) {

    } else {
      _items[productId] = CartItem(id: DateTime.now().toString(), qty: qty, title: title, price: price);
    }
  }
}

class CartItem {
  final String id;
  final String title;
  int qty = 1;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.qty,
    required this.price,
  });
}