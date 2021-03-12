import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/orders.dart' show Orders;
import '../Widget/order_item.dart';
import '../Widget/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, index) => OrderItem(
                orderData.orders[index],
              )),
    );
  }
}
