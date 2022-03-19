import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders/orders.dart';

import '../../widgets/order_item/order_item.dart' as orderItemWidget;

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const route = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });

    () async {
      await context.read<Orders>().fetchOrders();
      setState(() {
        _isLoading = false;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = context.read<Orders>();
    print('orders length ${orderState.orders.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('orders'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) => orderItemWidget.OrderItem(
                  key: ValueKey(orderState.orders[index].id),
                  title: orderState.orders[index].amount.toString(),
                  total: orderState.orders[index].amount,
                  dateTime: orderState.orders[index].timeStump,
                  products: orderState.orders[index].products),
              itemCount: orderState.orders.length,
            ),
    );
  }
}
