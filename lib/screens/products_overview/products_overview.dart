import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products/products.dart';

import '../../providers/product/product.dart';
import '../../widgets/product_item/product_item.dart';

class ProductsOverview extends StatelessWidget {
  const ProductsOverview({Key? key}) : super(key: key);

  static final List<ProductModel> loadedProducts = [];

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<Product>();
    final loadedProducts = productsData.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopify',
        ),
      ),
      body: GridView.builder(
        itemBuilder: (context, index) {
          final product = loadedProducts[index];

          return ChangeNotifierProvider(
            create: (_) => product,
            child: ProductItem(),
          );
        },
        itemCount: loadedProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
