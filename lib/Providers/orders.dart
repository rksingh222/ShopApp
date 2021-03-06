
import './cart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://checkflutterapi-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(url);
    print(json.decode(response.body));

    final List<OrderItem> loadedOrder = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if(extractedData == null){
      return ;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']),
              )
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });

    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double price) async {
    final url =
        'https://checkflutterapi-default-rtdb.firebaseio.com/orders.json';

    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': price,
          'dateTime': timeStamp.toIso8601String(),
          'products': products
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: price,
        products: products,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
