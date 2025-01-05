import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/screens/details/view_model/product_details_provider.dart';
import 'package:shop_sphere/screens/home/view_model/home_provider.dart';
import 'package:shop_sphere/screens/login/view_model/login_view_model.dart';
import 'package:shop_sphere/screens/products/view_model/products_provider.dart';
import 'package:shop_sphere/utils/app_routes.dart';
import 'package:shop_sphere/utils/shared_prefs_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.initialize(); // Initialize SharedPreferences
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getInitialRoute() async {
    final token = SharedPrefsHelper.getString('token');
    return token != null
        ? AppRoutes.home
        : AppRoutes.login; // Navigate based on token existence
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _getInitialRoute(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => HomeProvider()),
              ChangeNotifierProvider(create: (_) => ProductProvider()),
              ChangeNotifierProvider(create: (_) => ProductDetailsProvider()),
              ChangeNotifierProvider(create: (_) => LoginProvider()),
              // ChangeNotifierProvider(create: (_) => DetailsProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ShopSphere',
              theme: ThemeData(primarySwatch: Colors.blue),
              initialRoute: snapshot.data, // Set the initial route
              routes: AppRoutes.routes, // Register all routes
            ),
          );
        });
  }
}
