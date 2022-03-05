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
      appBar: AppBar(
        title: Text(
          product.title,
        ),
      ),
      body: Container(
        child: Text('product details $productId'),
      ),
    );
  }
}
