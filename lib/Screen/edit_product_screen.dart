import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/product.dart';
import '../Providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var isInit = true;
  var isLoading = false;

  @override
  void dispose() {
    //I have to call dispose because i was getting error removed them
    //_priceFocusNode.dispose();
    //_descriptionFocusNode.dispose();
    //_imageUrlController.dispose();
    //_imageUrlFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') ||
          !_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('jpg') &&
              !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isInit = false;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async{
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.price);
    if (_editedProduct.id != null) {
      print('edited product id is not null');
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
    } else {
      print('edited product id is  null');
      try {
        print('Inside try block');
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      }
      catch(error){
        print('Inside catch');
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An Error Occured'),
              content: Text('Something Went Wrong'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text('ok'),
                )
              ],
            ));
      }
      finally {
        print('finally called');
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  /*
   using catchError in saveform

    void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.price);
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((onError) {
         showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An Error Occured'),
                  content: Text('Something Went Wrong'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('ok'),
                    )
                  ],
                ));
      }).then((_) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: _saveForm,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please provide a value";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        }
                        if (double.parse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: double.parse(value),
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValues['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Should be atleast 10 character long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: value,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8.0,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Container(
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Image Url',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide an image Url';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid Url';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpge')) {
                                return 'Please enter a valid image Url';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
