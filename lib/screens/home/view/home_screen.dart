import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/screens/home/view_model/home_provider.dart';
import 'package:shop_sphere/screens/products/view/products_screen.dart';
import 'package:shop_sphere/utils/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<HomeProvider>(context, listen: false).fetchCategories();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSphere'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (homeProvider.categories.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          return ListView.builder(
            itemCount: homeProvider.categories.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final category = homeProvider.categories[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(category.toUpperCase()),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProductsScreen(
                        category: category,
                      );
                    },
                  )),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
