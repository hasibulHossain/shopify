import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart/cart.dart';
import 'providers/products/products.dart';
import 'providers/orders/orders.dart' show Orders;

import './screens/products_overview/products_overview.dart';
import './screens/product_details/product_details.dart';
import './screens/cart/cart.dart' as cartScreen;
import './screens/order/order.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Product(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
        ).copyWith(
          secondary: Colors.grey,
        ),
        primarySwatch: Colors.teal,
      ),
      // home: const ProductsOverview(),
      routes: {
        '/': (context) => const ProductsOverview(),
        ProductDetails.route: (context) => const ProductDetails(),
        cartScreen.Cart.route: (context) => const cartScreen.Cart(),
        OrderScreen.route: (context) => const OrderScreen(),
      },
    );
  }
}
