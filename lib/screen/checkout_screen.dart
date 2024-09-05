import 'package:flutter/material.dart';
import 'package:fluttterapp/const/colors_const.dart';
import 'package:provider/provider.dart';

import '../components/message_components.dart';
import '../services/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
        backgroundColor: app_primary_color,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final product = cartProvider.items[index];
                  return ListTile(
                    leading: Image.network(product.image),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            Text('Total: \$${cartProvider.totalPrice}',
                style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
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
                showSnackBarSuccess(context, 'Order placed successfully');

                cartProvider.items.clear();
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
