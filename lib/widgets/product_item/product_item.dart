import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/product_details/product_details.dart';
import '../../providers/product/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

  const ProductItem({
    Key? key,
    //   required this.id,
    //   required this.title,
    //   required this.imageUrl,
    //   required this.price,
  }) : super(key: key);

  void productTapHandler(BuildContext context, String route, String id) {
    Navigator.of(context).pushNamed(route, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context, listen: false);
    print('had run product item build method');
    return GestureDetector(
      onTap: () => productTapHandler(
        context,
        ProductDetails.route,
        product.id,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            leading: Consumer<ProductModel>( // If we want to change state on a certain portion of the widget without running build method for state change. To achieve this we can wrap that portion with consumer, now only this portion of widget will update without build full widget.
              builder: (_, product, child) => IconButton(
                icon: Icon(
                  product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  product.toggleFavorite();
                },
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {},
            ),
            backgroundColor: Colors.black54,
          ),
        ),
      ),
    );
  }
}
