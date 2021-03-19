import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import '../Widget/user_product_item.dart';
import '../Widget/app_drawer.dart';
import '../Screen/edit_product_screen.dart';

class UsersProductScreen extends StatelessWidget {
  static const routeName = '/UsersProduct';


  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchandsetproducts();
  }


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
      body: RefreshIndicator(
        onRefresh: (){
         return _refreshProducts(context);
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.item.length,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  UserProductItem(
                    productsData.item[index].id,
                    productsData.item[index].title,
                    productsData.item[index].imageUrl,
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
