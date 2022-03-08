import 'package:flutter/foundation.dart';
import '../cart/cart.dart' show CartItem;

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void placeOrder(List<CartItem> cartItem, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartItem,
        timeStump: DateTime.now(),
      ),
    );
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime timeStump;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.timeStump,
  });
}
