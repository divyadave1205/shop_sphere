// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/screens/details/view_model/product_details_provider.dart';
import 'package:shop_sphere/screens/products/model/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
  });
  final ProductModel product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Future<void> _addToCart() async {
    try {
      await Provider.of<ProductDetailsProvider>(context, listen: false)
          .addToCart(widget.product.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to Cart'.toString())),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _removeFromCart() async {
    try {
      await Provider.of<ProductDetailsProvider>(context, listen: false)
          .removeFromCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed to Cart'.toString())),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSphere'),
      ),
      body: Consumer<ProductDetailsProvider>(
        builder: (context, productDetailsProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  height: 300,
                  width: MediaQuery.sizeOf(context).width - 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.product.image,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  widget.product.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Price: ${widget.product.price}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Rating: ${widget.product.rating.rate}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                productDetailsProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: productDetailsProvider.isSuccess
                            ? _removeFromCart
                            : _addToCart,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: Text(
                          productDetailsProvider.isSuccess
                              ? 'Remove From Cart'
                              : "Add To Cart",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                SizedBox(height: 20),
                productDetailsProvider.isSuccess
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              productDetailsProvider.updateCart(
                                  widget.product.id,
                                  productDetailsProvider.quantity + 1);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.blueAccent,
                              child: Center(child: Icon(Icons.add)),
                            ),
                          ),
                          productDetailsProvider.isQuantityLoading
                              ? CircularProgressIndicator()
                              : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(productDetailsProvider.quantity
                                      .toString()),
                                ),
                          GestureDetector(
                            onTap: () async {
                              productDetailsProvider.updateCart(
                                  widget.product.id,
                                  productDetailsProvider.quantity - 1);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.blueAccent,
                              child: Center(child: Icon(Icons.remove)),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
