import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../utils/constants.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isFavorite,
    required this.price,
  });

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      await Dio().patch('$BASE_URL/products/$id.json', data: {'isFavorite': isFavorite});
    } catch(err) {
      print(err);
      rethrow;
    }
  }
}
