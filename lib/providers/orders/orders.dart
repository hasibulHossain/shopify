import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shopify/utils/constants.dart';

import '../cart/cart.dart' show CartItem;

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    try {
      final response = await Dio().get(ORDERS_URI);
      final orders = response.data as Map<String, dynamic>?;
      final List<OrderItem> loadedOrders = [];

      if(orders == null) {
        _orders = [];
        return;
      }

      orders.forEach((orderId, order) {
        final cartItems = (order['products'] as List<dynamic>).map((item) => CartItem(id: item['id'], title: item['title'], qty: item['qty'], price: item['price'])).toList();

        loadedOrders.add(
          OrderItem(
            id: orderId, 
            amount: order['amount'], 
            products: cartItems, 
            timeStump: DateTime.parse(order['timeStump']),
          )
        );
      });

      _orders = loadedOrders;

      notifyListeners();

    } catch(err) {
      print('fetch order err $err');
    }
  }

  Future<void> placeOrder (List<CartItem> cartItems, double total) async {
    final timeStump = DateTime.now();

    try {
      final response = await Dio().post(ORDERS_URI, data: {
        'amount': total,
        'products': cartItems.map((cartProd) => {
          'id': cartProd.id,
          'title': cartProd.title,
          'qty': cartProd.qty,
          'price': cartProd.price
        }).toList(),
        'timeStump': timeStump.toIso8601String()
      });

      _orders.insert( 
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          products: cartItems,
          timeStump: timeStump,
        ),
      );
    } catch(err) {
      print(err);
    }
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
