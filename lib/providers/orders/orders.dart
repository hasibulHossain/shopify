import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../providers/auth/auth.dart';
import 'package:shopify/utils/constants.dart';

import '../cart/cart.dart' show CartItem;

class Orders with ChangeNotifier {
  Orders(Auth auth) : _accessToken = auth.token, _userId = auth.userId;
  String? _accessToken;
  String? _userId;

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void update(Auth auth) {
    _accessToken = auth.token;
  }

  Future<void> fetchOrders() async {
    if (_accessToken == null) return;

    try {
      final response = await Dio().get('$BASE_URL/orders/$_userId.json?auth=$_accessToken');
      final orders = response.data as Map<String, dynamic>?;
      final List<OrderItem> loadedOrders = [];

      if (orders == null) {
        _orders = loadedOrders;
        return;
      }

      orders.forEach((orderId, order) {
        final cartItems = (order['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                title: item['title'],
                qty: item['qty'],
                price: item['price'],
              ),
            )
            .toList();

        loadedOrders.add(OrderItem(
          id: orderId,
          amount: order['amount'],
          products: cartItems,
          timeStump: DateTime.parse(order['timeStump']),
        ));
      });

      _orders = loadedOrders;

      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> placeOrder(List<CartItem> cartItems, double total) async {
    final timeStump = DateTime.now();

    try {
      final response =
          await Dio().post('$BASE_URL/orders/$_userId.json?auth=$_accessToken', data: {
        'amount': total,
        'products': cartItems
            .map((cartProd) => {
                  'id': cartProd.id,
                  'title': cartProd.title,
                  'qty': cartProd.qty,
                  'price': cartProd.price,
                  'createdBy': _userId,
                })
            .toList(),
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
    } catch (err) {
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
