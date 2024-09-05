import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttterapp/screen/login_screen.dart';
import '../screen/product_list_screen.dart';
import 'fire_authentication_page.dart';

class Main_Page extends StatelessWidget {
  const Main_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ProductListScreen();
          } else {
            return LogIN_Screen();
          }
        },
      ),
    );
  }
}
