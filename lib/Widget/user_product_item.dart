import 'package:flutter/material.dart';
import '../Screen/edit_product_screen.dart';
import '../Providers/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id,this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(this.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
              },
              color: Colors.blue,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                }
                catch(onError){
                  scaffold.showSnackBar(SnackBar(content: Text('Deleting Failed',textAlign: TextAlign.center,),));
                }
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
