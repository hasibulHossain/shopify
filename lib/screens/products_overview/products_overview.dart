import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/badge/badge.dart';
import '../../providers/products/products.dart';

import '../../providers/cart/cart.dart';
import '../../widgets/product_item/product_item.dart';
import '../cart/cart.dart' as cartScreen;
import '../order/order.dart';
import '../all_products/all_products.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Future<void> test() async {
      await context.read<Product>().fetchAllProducts();
      setState(() {
        _isLoading = false;
      });
    }

    ;

    test();

    // context.read<Product>().fetchAllProducts().then((value) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<Product>();
    final loadedProducts =
        _isFavoriteShow ? productsData.favProducts : productsData.products;

    return Scaffold(
      drawer: const Drawer(child: MainDrawer()),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
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

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  void routeHandler(String route, BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(route);
  }

  Widget _drawerItem(
      String title, IconData icon, BuildContext context, String route) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      onTap: () => routeHandler(route, context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 120,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          color: Theme.of(context).colorScheme.secondary,
          child: Text(
            'Shopify',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _drawerItem('Home', Icons.restaurant, context, '/'),
        _drawerItem('Order', Icons.filter_alt, context, OrderScreen.route),
        _drawerItem('All products', Icons.align_vertical_center_sharp, context,
            AllProducts.route),
      ],
    );
  }
}
