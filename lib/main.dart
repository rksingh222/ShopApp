import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './Screen/products_overview_screen.dart';
import './Screen/products_detail_screen.dart';
import './Screen/users_product_screen.dart';
import './Screen/cart_screen.dart';
import './Screen/order_screen.dart';
import './Screen/edit_product_screen.dart';
import './Providers/products.dart';
import './Providers/cart.dart';
import './Providers/orders.dart';
import './Screen/auth_screen.dart';
import './Providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(builder: (ctx) => Auth(),),
      ],
      child: MaterialApp(
        title: 'My Shop',
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
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthScreen(),
        routes: {
          ProductsDetailScreen.routeName: (ctx) => ProductsDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UsersProductScreen.routeName: (ctx) => UsersProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),

        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: Center(
        child: Text('Cart Application'),
      ),
    );
  }
}
