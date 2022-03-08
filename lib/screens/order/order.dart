import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders/orders.dart';

import '../../widgets/order_item/order_item.dart' as orderItemWidget;

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const route = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderState = context.watch<Orders>();
    print('orders length ${orderState.orders.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('orders'),
      ),
      body: ListView.builder(
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
