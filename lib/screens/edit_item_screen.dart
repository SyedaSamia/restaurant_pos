import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantpos/providers/item_model.dart';
import 'package:restaurantpos/providers/items_provider.dart';

class EditItemScreen extends StatefulWidget {
  static const routeName = '/edit-item';

  @override
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _priceFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  //final _restaurantFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedItem = ItemModel(
    id: null,
    title: '',
    price: 0,
    category: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'category': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final itemId = ModalRoute.of(context).settings.arguments as String;
      if (itemId != null) {
        _editedItem =
            Provider.of<ItemsProvider>(context, listen: false).findById(itemId);
        _initValues = {
          'title': _editedItem.title,
          'category': _editedItem.category,
          'price': _editedItem.price.toString(),
          //    'imageUrl': _editedItem.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedItem.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _categoryFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedItem.id != null) {
      await Provider.of<ItemsProvider>(context, listen: false)
          .updateItem(_editedItem.id, _editedItem);
    } else {
      try {
        await Provider.of<ItemsProvider>(context, listen: false)
            .addItem(_editedItem);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['Item Name'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = ItemModel(
                          title: value,
                          price: _editedItem.price,
                          category: _editedItem.category,
                          imageUrl: _editedItem.imageUrl,
                          id: _editedItem.id,
                          //  isFavorite: _editedItem.isFavorite
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_categoryFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = ItemModel(
                          title: _editedItem.title,
                          price: double.parse(value),
                          category: _editedItem.category,
                          imageUrl: _editedItem.imageUrl,
                          id: _editedItem.id,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['category'],
                      decoration: InputDecoration(labelText: 'Category'),
                      //maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _categoryFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter category.';
                        }
                        /* if (value.length < 2) {
                    return 'Should be at least 3 characters long.';
                  }*/
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = ItemModel(
                          title: _editedItem.title,
                          price: _editedItem.price,
                          category: value,
                          imageUrl: _editedItem.imageUrl,
                          id: _editedItem.id,
                          // isFavorite: _editedItem.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedItem = ItemModel(
                                title: _editedItem.title,
                                price: _editedItem.price,
                                category: _editedItem.category,
                                imageUrl: value,
                                id: _editedItem.id,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
