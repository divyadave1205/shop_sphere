import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_sphere/screens/products/model/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> products = [];
  bool isLoading = false;

  /// Fetch categories from API
  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();

    const url = 'https://fakestoreapi.com/products';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        products = List<ProductModel>.from(
          json.decode(response.body).map(
                (e) => ProductModel.fromJson(e),
              ),
        );
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to fetch categories: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
