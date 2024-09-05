import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttterapp/screen/login_screen.dart';
import 'package:http/http.dart' as http;

import '../components/message_components.dart';
import '../model/product_modle.dart';

class ProductService {
  final String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts(int page, int limit) async {
    final response = await http.get(Uri.parse('$_baseUrl?_page=$page&_limit=$limit'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}


final FirebaseAuth _auth = FirebaseAuth.instance;

void to() {
  bool a = false;
}

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {

                try {
                  await _auth.signOut();
                  showSnackBarError(context, 'Logging Out ');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogIN_Screen(),
                    ),
                  );

                } catch (e) {

                }
              },
            ),
          ],
        );
      },
    );
  }