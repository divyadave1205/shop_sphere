import 'package:flutter/material.dart';
import 'package:shop_sphere/screens/home/view/home_screen.dart';
import 'package:shop_sphere/screens/login/view/login_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        home: (context) => const HomeScreen(),
      };
}
