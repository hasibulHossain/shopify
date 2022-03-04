import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/providers/product.dart';

import '../../models/product/product.dart';
import '../../widgets/product_item/product_item.dart';
import '../product_details/product_details.dart';

class ProductsOverview extends StatelessWidget {
  const ProductsOverview({Key? key}) : super(key: key);

  static final List<ProductModel> loadedProducts = [];

  void productTapHandler(BuildContext context, String route, String id) {
    Navigator.of(context).pushNamed(route, arguments: id);
  }

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

          return InkWell(
            onTap: () => productTapHandler(context, ProductDetails.route, product.id,),
            child: ProductItem(
              id: product.id,
              title: product.title,
              imageUrl: product.imageUrl,
              price: product.price,
            ),
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
