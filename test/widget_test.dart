// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:fluttterapp/main.dart';
//
// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget( MyApp());
//
//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);
//
//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();
//
//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttterapp/model/product_modle.dart';
import 'package:fluttterapp/screen/product_list_screen.dart';
import 'package:fluttterapp/services/cart_provider.dart';
import 'package:fluttterapp/services/product_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockProductService extends Mock implements ProductService {}
class MockCartProvider extends Mock implements CartProvider {}

void main() {
  testWidgets('ProductListScreen initializes and loads products', (WidgetTester tester) async {
    final mockProductService = MockProductService();
    final mockCartProvider = MockCartProvider();

    when(mockProductService.fetchProducts(any, any))
        .thenAnswer((_) async => [
      Product(id: '1', title: 'Test Product', description: 'Test Description', price: 9.99, image: 'https://example.com/image.png', category: 'All'),
    ]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProductService>(create: (_) => mockProductService),
          Provider<CartProvider>(create: (_) => mockCartProvider),
        ],
        child: MaterialApp(
          home: ProductListScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$9.99'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('ProductListScreen filters products based on search query', (WidgetTester tester) async {
    final mockProductService = MockProductService();
    final mockCartProvider = MockCartProvider();

    when(mockProductService.fetchProducts(any, any))
        .thenAnswer((_) async => [
      Product(id: '1', title: 'Search Product', description: 'Test Description', price: 9.99, image: 'https://example.com/image.png', category: 'All'),
    ]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProductService>(create: (_) => mockProductService),
          Provider<CartProvider>(create: (_) => mockCartProvider),
        ],
        child: MaterialApp(
          home: ProductListScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Search Product');
    await tester.pump();

    expect(find.text('Search Product'), findsOneWidget);
    expect(find.text('No results'), findsNothing);
  });

  testWidgets('ProductListScreen loads more products on scroll', (WidgetTester tester) async {
    final mockProductService = MockProductService();
    final mockCartProvider = MockCartProvider();

    when(mockProductService.fetchProducts(any, any))
        .thenAnswer((_) async => [
      Product(id: '1', title: 'Product 1', description: 'Test Description', price: 9.99, image: 'https://example.com/image.png', category: 'All'),
      Product(id: '2', title: 'Product 2', description: 'Test Description', price: 19.99, image: 'https://example.com/image.png', category: 'All'),
    ]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ProductService>(create: (_) => mockProductService),
          Provider<CartProvider>(create: (_) => mockCartProvider),
        ],
        child: MaterialApp(
          home: ProductListScreen(),
        ),
      ),
    );

    final scrollController = ScrollController();
    await tester.drag(find.byType(ListView), Offset(0, -300));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
