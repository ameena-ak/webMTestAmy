
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttterapp/const/colors_const.dart';
import 'package:provider/provider.dart';
import '../model/product_modle.dart';
import '../services/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: app_primary_color,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(product.image),
              SizedBox(height: 16.0),
              Text(
                product.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('\$${product.price}', style: TextStyle(fontSize: 20.0)),
              SizedBox(height: 16.0),
              Text(product.description),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: app_primary_color,
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      cartProvider.add(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.title} added to cart')),
                      );
                    },
                    child: Text('Add to Cart'),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: app_primary_color,
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Share.share(
                        'Check out this product: ${product.title}\n${product.description}\nPrice: \$${product.price}\n${product.image}',
                        subject: 'Product Share',
                      );
                    },
                    child: Text('Share'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),

            ],
          ),
        ),
      ),
    );
  }
}
