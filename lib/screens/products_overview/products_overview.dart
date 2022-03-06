import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/widgets/badge/badge.dart';
import '../../providers/products/products.dart';

import '../../providers/cart/cart.dart';
import '../../widgets/product_item/product_item.dart';
import '../cart/cart.dart' as cartScreen;

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverview extends StatefulWidget {
  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _isFavoriteShow = false;

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<Product>();
    final loadedProducts =
        _isFavoriteShow ? productsData.favProducts : productsData.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopify',
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.all) {
                  _isFavoriteShow = false;
                }
                if (value == FilterOptions.favorite) {
                  _isFavoriteShow = true;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.all,
              ),
              const PopupMenuItem(
                child: Text('Favorite'),
                value: FilterOptions.favorite,
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child as Widget,
              value: cart.cartCount.toString(),
              color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(cartScreen.Cart.route);
              },
            ),
          ),
        ],
      ),
      body: GridView.builder(
        itemBuilder: (context, index) {
          final product = loadedProducts[index];

          return ChangeNotifierProvider.value(
            // problem is here cause changenotifierprovider is immediately remove when dispose call. fix:
            value: product,
            child: ProductItem(
              key: ValueKey(index),
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
