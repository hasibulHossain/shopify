import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products/products.dart';

class EditProduct extends StatefulWidget {
  static const route = '/edit-product';

  const EditProduct({Key? key}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  String? _productId;
  String _title = '';
  double _price = 0;
  String _description = '';
  String _imageUrl = '';

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    //  we use didChangeDependencies insted of initstate because of Modalroute. ModalRoute not work in initState. initState is too early to access modalRoute. and also didchangedependencies run before build method.
    final productId = ModalRoute.of(context)?.settings.arguments;

    if(productId != null) {
      final product = context.read<Product>().findProduct(productId as String);
      _productId = product.id;
      _title = product.title;
      _price = product.price;
      _description = product.description;
      _imageUrlController.text = product.imageUrl;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();

    if(!isValid) return;

    _form.currentState!.save();

    final productState = context.read<Product>();

    if(_productId == null) {
      productState.addProduct(_title, _description, _imageUrl, _price);
    } else {
      productState.updateProduct(_productId as String, _title, _price, _description, _imageUrl);
    }

    Navigator.of(context).pop();
  }

  String? isInputValid(String fieldName, String? inputVal) {
    switch (fieldName) {
      case 'title':
        if(inputVal == null || inputVal.isEmpty) return 'Please input product name.';
        return null;
      
      case 'price':
        if(inputVal == null || inputVal.isEmpty) return 'Product price should not be not 0.';
        if(double.parse(inputVal) <= 0) return 'haha your product price is 0';
        return null;

      case 'description':
        if(inputVal == null || inputVal.isEmpty) return 'Please add a description.';
        return null;

      case 'imageUrl':
        if(inputVal == null || inputVal.isEmpty) return 'Image Url needed.';
        return null;

      default:
        return 'Something went wrong.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [ 
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title',),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  // this code will change current focus input to price input;
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (newValue) => newValue != null ? _title = newValue : _title = '',
                validator: (value) => isInputValid('title', value),
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                focusNode: _priceFocusNode,
                validator: (value) {
                  return isInputValid('price', value);
                },
                onSaved: (newValue) => newValue != null ? _price = double.parse(newValue) : _price = 0,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) => isInputValid('description', value),
                onSaved: (newValue) => newValue != null ? _description = newValue : _description = '',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Image Url')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image url',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      validator: (value) => isInputValid('imageUrl', value),
                      onSaved: (newValue) => newValue != null ? _imageUrl = newValue : _imageUrl = '',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
