import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop_app/Providers/product.dart';
import 'package:real_shop_app/Providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit_product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFucosNode = FocusNode();
  final _descriptionFucosNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFucosNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );
  var _initialValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };
  var _isInit = true;
  var _isLoading = false;

  initState() {
    super.initState();
    _imageUrlFucosNode.addListener(_updateImageUrl);
  }

  didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFucosNode.removeListener(_updateImageUrl);
    _priceFucosNode.dispose();
    _descriptionFucosNode.dispose();
    _imageUrlFucosNode.dispose();
    _imageUrlController.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFucosNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.startsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("An error occured!"),
                  content: Text("Something went wrong!"),
                  actions: [
                    FlatButton(
                        child: Text("Okay!"),
                        onPressed: () => Navigator.of(ctx).pop())
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValues["title"],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFucosNode),
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please provide a value";
                        else
                          return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues["price"],
                      decoration: InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFucosNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFucosNode),
                      validator: (value) {
                        if (value.isEmpty) return "Please enter a valid price.";
                        if (double.tryParse(value) == null)
                          return "Please enter a valid number.";
                        if (double.parse(value) <= 0)
                          return "Please enter a number greater then zero.";
                        else
                          return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValues["description"],
                      decoration: InputDecoration(labelText: "Description"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFucosNode,
                      validator: (value) {
                        if (value.isEmpty)
                          return "Please enter a description.";
                        if (value.length < 10)
                          return "Should be at least 10 characters long  ";
                        else
                          return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavourite: _editedProduct.isFavourite);
                      },
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Enter a URL")
                              : FittedBox(
                                  child: Image.network(_imageUrlController.text,
                                      fit: BoxFit.cover))),
                      Expanded(
                        child: TextFormField(
                          controller: _imageUrlController,
                          decoration: InputDecoration(labelText: "Image URL"),
                          keyboardType: TextInputType.url,
                          focusNode: _imageUrlFucosNode,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_priceFucosNode),
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please enter a image URL";
                            if (!value.startsWith("http") &&
                                !value.startsWith("https"))
                              return "Please enter a valid URL";
                            if (!value.endsWith("png") &&
                                !value.endsWith("jpg") &&
                                !value.endsWith("jpeg"))
                              return "Please enter a valid URL";
                            else
                              return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: value,
                                isFavourite: _editedProduct.isFavourite);
                          },
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ),
    );
  }
}
