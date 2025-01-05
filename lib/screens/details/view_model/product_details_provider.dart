import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop_sphere/screens/details/model/cart_model.dart';

class ProductDetailsProvider with ChangeNotifier {
  bool isLoading = false;
  bool isSuccess = false;
  List<CartModel>? _products;

  List<CartModel> get products => _products ?? [];

  /// Fetch categories from API
  Future<void> getCart() async {
    isLoading = true;
    notifyListeners();

    const url = 'https://fakestoreapi.com/carts/user/2';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        _products = List<CartModel>.from((json.decode(response.body))
            .first['products']
            .map((e) => CartModel.fromJson(e)));
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
        await getCart();
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

    final url = ' https://fakestoreapi.com/carts/3/remove';
    try {
      final response = await http.delete(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        await getCart();
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
    isLoading = true;
    notifyListeners();

    final url = ' https://fakestoreapi.com/carts/3';
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
        await getCart();
      } else {
        throw Exception('Failed to update cart');
      }
    } catch (error) {
      throw Exception('Failed to update cart: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
