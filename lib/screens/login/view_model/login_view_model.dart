import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_sphere/utils/shared_prefs_helper.dart';

class LoginProvider extends ChangeNotifier {
  String? _token;
  bool? _isLoading;

  String? get token => _token;
  bool? get isLoading => _isLoading;

  bool isLoggedIn = SharedPrefsHelper.getString('token') != null &&
      SharedPrefsHelper.getString('token')!.isNotEmpty;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    const url = "https://fakestoreapi.com/auth/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        _isLoading = false;

        final data = jsonDecode(response.body);

        _token = data["token"];
        await SharedPrefsHelper.setString('token', _token ?? '');
      } else {
        _isLoading = false;

        throw Exception("Login failed. Please check your credentials.");
      }
    } catch (error) {
      _isLoading = false;

      throw Exception("An error occurred: $error");
    } finally {
      notifyListeners();
    }
  }

  void logout() async {
    _token = null;
    await SharedPrefsHelper.clear();
    notifyListeners();
  }
}
