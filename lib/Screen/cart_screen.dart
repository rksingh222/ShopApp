import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart';
import '../Widget/cart_item.dart' as si;
import '../Providers/orders.dart';
class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),

                Spacer(),
                Chip(
                  label: Text('\$ ${cart.totalAmount}'),
                  backgroundColor: Colors.blue,
                ),
                FlatButton(
                  onPressed: () {
                    Provider.of<Orders>(context, listen: false,).addOrder(cart.items.values.toList(), cart.totalAmount);
                    cart.clear();
                  },
                  child: Text(
                    'Order Now',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) {
                return si.CartItem(
                    cart.items.values.toList()[index].id,
                    cart.items.keys.toList()[index],
                    cart.items.values.toList()[index].price,
                    cart.items.values.toList()[index].quantity,
                    cart.items.values.toList()[index].title);
              },
            ),
          ),
        ],
      ),
    );
  }
}
