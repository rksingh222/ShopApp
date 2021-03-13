import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import '../Widget/user_product_item.dart';
import '../Widget/app_drawer.dart';
import '../Screen/edit_product_screen.dart';

class UsersProductScreen extends StatelessWidget {
  static const routeName = '/UsersProduct';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.item.length,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                UserProductItem(
                  productsData.item[index].title,
                  productsData.item[index].imageUrl,
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
