import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart/cart.dart' as cartProvider;
import '../../providers/orders/orders.dart';

import '../../widgets/cart_item/cart_item.dart';

class Cart extends StatelessWidget {
  const Cart({Key? key}) : super(key: key);

  static const route = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<cartProvider.Cart>();
    final orderState = context.read<Orders>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('cart'),
        ),
        body: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total'),
                    const SizedBox(
                      width: 10,
                    ),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        '\$ ${cart.totalSum}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.cartCount,
                itemBuilder: (ctx, i) => CartItem(
                  prodId: cart.items.keys.toList()[i],
                  qty: cart.items.values.elementAt(i).qty,
                  title: cart.items.values.elementAt(i).title,
                  unitPrice: cart.items.values.elementAt(i).price,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('ORDER'),
          onPressed: cart.cartCount == 0 ? null : () async {
            await orderState.placeOrder(
                cart.items.values.toList(), cart.totalSum.toDouble());

            cart.emptyCart();
          },
        ));
  }
}
