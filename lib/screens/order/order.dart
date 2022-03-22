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
    // TODO: implement initState
    super.initState();

    () async {
      await context.read<Orders>().fetchOrders();
      setState(() {
        _isLoading = false;
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    print('running from order build [order.dart]');

    return Scaffold(
      appBar: AppBar(
        title: const Text('orders'),
      ),
      body: FutureBuilder(
        future: context.read<Orders>().fetchOrders(),
        builder: (context, dataSnapshot) {
          print('from futurebuilder');
          
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (dataSnapshot.error != null) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }

          return Consumer<Orders>(
            builder: (context, orderState, child) => ListView.builder(
              itemBuilder: (context, index) => orderItemWidget.OrderItem(
                key: ValueKey(orderState.orders[index].id),
                title: orderState.orders[index].amount.toString(),
                total: orderState.orders[index].amount,
                dateTime: orderState.orders[index].timeStump,
                products: orderState.orders[index].products,
              ),
              itemCount: orderState.orders.length,
            ),
          );
        },
      ),
    );
  }
}