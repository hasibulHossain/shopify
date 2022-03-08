import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart/cart.dart';

class CartItem extends StatelessWidget {
  final String prodId;
  final int qty;
  final String title;
  final num unitPrice;

  const CartItem({
    Key? key,
    required this.prodId,
    required this.qty,
    required this.title,
    required this.unitPrice,
  }) : super(key: key);

  num get totalPrice {
    return qty * unitPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(prodId),
      background: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: const Icon(
          Icons.delete,
          size: 30,
          color: Colors.red,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 10,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Cart item will be delete!'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<Cart>().removeCartItem(prodId);
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Column(
              children: [
                const Text('Qty'),
                Text('$qty'),
              ],
            ),
          ),
          title: Text(title),
          subtitle: Text('Unit price $unitPrice'),
          trailing: Text('\$ $totalPrice'),
        ),
      ),
    );
  }
}
