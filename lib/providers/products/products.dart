import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../utils/constants.dart';

import '../product/product.dart';
import '../auth/auth.dart';

class Product with ChangeNotifier {
  Product(Auth auth) : _authToken = auth.token, _userId = auth.userId;

  String? _authToken;
  String? _userId;

  List<ProductModel> _products = [
    // ProductModel(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   isFavorite: false,
    // ),
    // ProductModel(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   isFavorite: false,
    // ),
    // ProductModel(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   isFavorite: false,
    // ),
    // ProductModel(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   isFavorite: false,
    // ),
  ];

  List<ProductModel> get products {
    return [..._products];
  }

  void update(Auth auth) {
    _authToken = auth.token;
  }

  Future<void> fetchAllProducts({bool isFilteredByUser = false}) async {
    final filteredByUser = isFilteredByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    try {
      final response = await Dio().get('$PRODUCTS_URI?auth=$_authToken&$filteredByUser');
      final products = response.data as Map<String, dynamic>?;
      final List<ProductModel> loadedProducts = [];

      if(products == null) {
        _products = [];
        return;
      }

      products.forEach((productId, product) {
        loadedProducts.add(ProductModel(
            id: productId,
            title: product['title'],
            description: product['description'],
            imageUrl: product['imageUrl'],
            isFavorite: product['isFavorite'],
            price: product['price']));
      });

      _products = loadedProducts;

      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  List<ProductModel> get favProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  ProductModel findProduct(String id) {
    return _products.firstWhere((product) => product.id == id);
  }

  Future<void> addProduct(
      String title, String description, String imageUrl, double price) async {
    final url = '$PRODUCTS_URI?auth=$_authToken';

    final body = jsonEncode({
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': false,
    });

    try {
      final res = await Dio().post(url, data: body);

      _products.insert(
        0,
        ProductModel(
          id: res.data['name'],
          title: title,
          description: description,
          imageUrl: imageUrl,
          isFavorite: false,
          price: price,
        ),
      );
      notifyListeners();

      return Future.value();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, String title, double price,
      String description, String imageUrl) async {
    final index = _products.indexWhere((product) => product.id == id);

    if (index != -1) {
      try {
        await Dio().patch('$BASE_URL/products/$id.json?auth=$_authToken', data: {
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
          'price': price
        });
        _products[index] = ProductModel(
          id: id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          isFavorite: _products[index].isFavorite,
          price: price,
        );
        notifyListeners();
      } catch (err) {
        rethrow;
      }
    } else {
      throw 'Product not found';
    }
  }

  void deleteProduct(String id) {
    final foundProdIndex = _products.indexWhere((element) => id == element.id);
    if(foundProdIndex == -1) return;

    ProductModel? foundProd = _products[foundProdIndex];

    _products.removeAt(foundProdIndex);
    notifyListeners();

    Dio().delete('$BASE_URL/products/$id.json?auth=$_authToken').then((value) {
      foundProd = null;
    }).catchError((err) {
      _products.insert(foundProdIndex, foundProd!);
      notifyListeners();
    });
  }
}
