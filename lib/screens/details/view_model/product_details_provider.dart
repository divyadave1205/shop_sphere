import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetailsProvider with ChangeNotifier {
  bool isLoading = false;
  bool isQuantityLoading = false;
  bool isSuccess = false;
  int _quantity = 1;

  int get quantity => _quantity;

  /// Fetch categories from API
  Future<void> addToCart(int productId) async {
    isLoading = true;
    notifyListeners();

    const url = 'https://fakestoreapi.com/carts';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'userId': 2,
            'products': [
              {
                'productId': productId,
                'quantity': 1,
              }
            ]
          },
        ),
      );
      if (response.statusCode == 200) {
        isSuccess = true;
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (error) {
      throw Exception('Failed to add to cart: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeFromCart() async {
    isLoading = true;
    notifyListeners();

    final url = 'https://fakestoreapi.com/carts/3';
    try {
      final response = await http.delete(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        isSuccess = false;
      } else {
        throw Exception('Failed to remove from cart');
      }
    } catch (error) {
      throw Exception('Failed to remove from cart: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCart(int productId, int quantity) async {
    isQuantityLoading = true;
    notifyListeners();

    final url = 'https://fakestoreapi.com/carts/3';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          {
            'productId': productId,
            'quantity': quantity,
          },
        ),
      );
      if (response.statusCode == 200) {
        _quantity = quantity;
      } else {
        throw Exception('Failed to update cart');
      }
    } catch (error) {
      throw Exception('Failed to update cart: $error');
    } finally {
      isQuantityLoading = false;
      notifyListeners();
    }
  }
}
