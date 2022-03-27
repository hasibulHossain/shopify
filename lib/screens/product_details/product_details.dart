import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products/products.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key}) : super(key: key);

  static const route = 'product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final product = context.read<Product>().findProduct(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     product.title,
      //   ),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 20,
                ),
                Text(product.title),
                Text('\$ ${product.price}'),
                const SizedBox(
                  height: 700,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
