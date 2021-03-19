
import 'dart:io';

import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  var _showFavoritesOnly = false;

  List<Product> get item {
    //if(_showFavoritesOnly){
    //  return _items.where((prodItem) => prodItem.isFavorite).toList();
    //}
    //else
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String Id) {
    return _items.firstWhere((product) => product.id == Id);
  }

/*
void showFavoritesOnly(){
   _showFavoritesOnly = true;
   notifyListeners();
}

void showAll(){
   _showFavoritesOnly = false;
   notifyListeners();
}
*/

  Future<void> fetchandsetproducts() async {
    const url = 'https://checkflutterapi-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://checkflutterapi-default-rtdb.firebaseio.com/products.json';
    try {
      print('addproduct');
      print('respone');
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      //when we are calling json.decode its throwing an error
      print(json.decode(response.body));

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: DateTime.now().toString(),
      );
      _items.add(newProduct);
      print('successful response');
      notifyListeners();
    } on HttpException catch (error) {
      print("unsuccessful response");
      print(error);
      throw error;
    } catch (error) {
      throw error;
    }
  }


  /*
  how to use catcherror code instead of try catch block

    Future<void> addProduct(Product product) {
    const url =
        'https://checkflutterapi-default-rtdb.firebaseio.com/products.json';
    return http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      }),
    ).then((response){
      print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: DateTime.now().toString(),
      );
      _items.add(newProduct);
      //_items.add(value);
      notifyListeners();
    }).catchError((onError){
      print(onError);
      throw onError;
    });

    //return Future.value();

  }

   */

  void deleteProduct(String id) {
    final url = 'https://checkflutterapi-default-rtdb.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeWhere((product) => product.id == id);
    http.delete(url).then((_) {
      existingProduct = null;
    }).catchError((onError){
      _items.insert(existingProductIndex, existingProduct);
    });
    notifyListeners();
  }

  Future <void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    print('UpdateIndex  $prodIndex');


    if (prodIndex >= 0) {
      final url = 'https://checkflutterapi-default-rtdb.firebaseio.com/products/$prodIndex.json';
      http.patch(url,body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
      }),);
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
