import 'package:flutter/material.dart';

import '../product/product.dart';

class Product with ChangeNotifier {
  final List<ProductModel> _products = [
    ProductModel(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      isFavorite: false,
    ),
    ProductModel(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      isFavorite: false,
    ),
    ProductModel(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      isFavorite: false,
    ),
    ProductModel(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      isFavorite: false,
    ),
  ];

  List<ProductModel> get products {
    return [..._products];
  }

  List<ProductModel> get favProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  ProductModel findProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  void addProduct(String title, String description, String imageUrl, double price) {
    _products.insert(
      0,
      ProductModel(
          id: DateTime.now().toString(),
          title: title,
          description: description,
          imageUrl: imageUrl,
          isFavorite: false,
          price: price),
    );
    notifyListeners();
  }

  void updateProduct(String id, String title, double price, String description, String imageUrl) {
    final index = _products.indexWhere((product) => product.id == id);

    if(index == -1) {
      print('product not found');
    } else {
      _products[index] = ProductModel(id: id, title: title, description: description, imageUrl: imageUrl, isFavorite: _products[index].isFavorite, price: price);
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((element) => element.id == id);
    notifyListeners();
  }
  // void addProduct(value) {
  //   _products.add(value);
  //   notifyListeners()
  // }
}
