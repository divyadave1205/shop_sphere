import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeProvider with ChangeNotifier {
  List<String> categories = [];
  bool isLoading = false;

  /// Fetch categories from API
  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    const url = 'https://fakestoreapi.com/products/categories';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        categories = List<String>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      throw Exception('Failed to fetch categories: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
