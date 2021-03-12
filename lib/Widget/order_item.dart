import 'package:flutter/material.dart';
import '../Providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: _expanded ? Icon(Icons.expand_less):Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView(
                children:
                  widget.order.products.map((prod) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(prod.title,style:TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                      Text('${prod.quantity} \$ ${prod.price}',style:TextStyle(fontSize:18,color: Colors.grey),),
                    ],
                  )).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
