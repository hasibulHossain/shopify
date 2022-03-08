import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products/products.dart' as ProductState;
import '../../widgets/product/product.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({Key? key}) : super(key: key);

  static const route = '/all-products';

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductState.Product>();

    return Scaffold(
      appBar: AppBar(
        title: Text('All products'),
      ),
      body: ListView(
        children: [
          ...productState.products.map(
            (item) => Column(
              children: [
                Product(
                  id: item.id,
                  title: item.title,
                  imgUrl: item.imageUrl,
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
