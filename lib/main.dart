import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/screens/splashScreen/splash_screen.dart';

import 'providers/cart/cart.dart';
import 'providers/products/products.dart';
import 'providers/orders/orders.dart' show Orders;
import 'providers/auth/auth.dart';

import './screens/products_overview/products_overview.dart';
import './screens/product_details/product_details.dart';
import './screens/cart/cart.dart' as cartScreen;
import './screens/order/order.dart';
import './screens/all_products/all_products.dart';
import './screens/edit_product_screen/edit_product_screen.dart';
import './screens/auth/auth.dart';

import './helpers/custom_route.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Product>(
          create: (context) =>
              Product(Provider.of<Auth>(context, listen: false)),
          update: (_, auth, previousProduct) =>
              previousProduct == null ? Product(auth) : previousProduct
                ..update(auth),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) =>
              Orders(Provider.of<Auth>(context, listen: false)),
          update: (_, auth, previousOrders) =>
              previousOrders == null ? Orders(auth) : previousOrders
                ..update(auth),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
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
    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
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
          pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CustomPageTransitionBuilder(), TargetPlatform.iOS: CustomPageTransitionBuilder()})
        ),
        home: auth.isAuth
            ? const ProductsOverview()
            : FutureBuilder(
                future: auth.autoLogin(),
                builder: (ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen(),
            ),
        routes: {
          ProductDetails.route: (context) => const ProductDetails(),
          cartScreen.Cart.route: (context) => const cartScreen.Cart(),
          OrderScreen.route: (context) => const OrderScreen(),
          AllProducts.route: (context) => const AllProducts(),
          EditProduct.route: (context) => const EditProduct(),
        },
      ),
    );
  }
}
