import 'package:flutter/material.dart';
import '../../providers/cart/cart.dart' show CartItem;

class OrderItem extends StatefulWidget {
  final String title;
  final double total;
  final DateTime dateTime;
  final List<CartItem> products;

  const OrderItem({
    Key? key,
    required this.title,
    required this.total,
    required this.dateTime,
    required this.products,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('${widget.total}'),
            subtitle: Text('${widget.dateTime}'),
            trailing: IconButton(
              icon: Icon(
                _isExpand ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _isExpand = !_isExpand;
                });
              },
            ),
          ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isExpand ? 150 : 0,
              child: ListView(
                children: widget.products.map((e) => Text(e.title)).toList(),
              ),
            )
        ],
      ),
    );
  }
}
