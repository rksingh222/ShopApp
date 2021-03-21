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
                OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () async{
        setState(() {
          _isLoading = true;
        });
             await Provider.of<Orders>(
                context,
                listen: false,
              ).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);

             setState(() {
               _isLoading = false;
             });
              widget.cart.clear();
            },
      child: _isLoading == true? CircularProgressIndicator():Text(
        'Order Now',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
