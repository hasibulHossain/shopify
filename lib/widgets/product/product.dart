import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products/products.dart' as prodState;

import '../../screens/edit_product_screen/edit_product_screen.dart';
class Product extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  const Product({
    Key? key,
    required this.id,
    required this.title,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
          ),
          title: Text(title),
          trailing: Container(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditProduct.route, arguments: id);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    context.read<prodState.Product>().deleteProduct(id);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
