import 'package:flutter/material.dart';

import '../models/product/product.dart';

class Product with ChangeNotifier {
  List<Product> _products = [];
  
  List<Product> get products {
    return [..._products];
  }
}