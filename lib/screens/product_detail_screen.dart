import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart';
import '../Providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product_detail";

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    final dh = MediaQuery.of(context).size.height;
    final dw = MediaQuery.of(context).size.width;
    var appBar = AppBar(title: Text(loadedProduct.title));
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: isLandscape
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: dh -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top,
                        minHeight: dh -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top,
                      ),
                      width: dw * 0.5,
                      child: Hero(
                        tag: loadedProduct.id,
                        child: Image.network(
                          loadedProduct.imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      width: dw*0.5-12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              loadedProduct.description,
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "\$${loadedProduct.price}",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight: dh * 0.6,
                        minHeight: dh * 0.3,
                      ),
                      child: Hero(
                        tag: loadedProduct.id,
                        child: Image.network(
                          loadedProduct.imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        loadedProduct.description,
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "\$${loadedProduct.price}",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 30),
                      ),
                    )
                  ],
                ),
        ),
        floatingActionButtonLocation: isLandscape
            ? FloatingActionButtonLocation.endFloat
            : FloatingActionButtonLocation.centerFloat,
        floatingActionButton: RaisedButton(
          onPressed: () {
            cart.addItem(loadedProduct.id, loadedProduct.price,
                loadedProduct.title, loadedProduct.imageUrl);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? dw * 0.157 : dw * 0.3,
              vertical: dh * 0.02),
          child: Text(
            "Add to Cart",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
          ),
        ));
  }
}

bool useWhiteForeground(Color backgroundColor) =>
    1.05 / (backgroundColor.computeLuminance() + 0.05) > 4.5;
