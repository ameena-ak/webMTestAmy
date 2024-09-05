import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttterapp/services/auth_provider.dart';
import 'package:fluttterapp/services/product_list_provider.dart';
import 'package:provider/provider.dart';
import 'authentication/auth_main_page.dart';
import 'firebase_options.dart';
import 'services/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),

      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Main_Page(),
      ),
    );
  }
}
