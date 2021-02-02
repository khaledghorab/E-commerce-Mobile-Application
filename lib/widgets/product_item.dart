import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/auth.dart';
import '../Providers/cart.dart';
import '../Providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
            child: GestureDetector(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  height: 140,
                  child: Stack(
                    children: [
                      Center(
                        child: Hero(
                          tag: product.id,
                          child: FadeInImage(
                            placeholder: AssetImage(
                                "assets/images/product-placeholder.png"),
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Consumer<Product>(
                            builder: (ctx, product, _) => IconButton(
                              icon: Icon(product.isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_outline),
                              color: product.isFavourite
                                  ? Theme.of(context).accentColor
                                  : Colors.black,
                              onPressed: () {
                                product.toggleFavouriteStatus(
                                    authData.token, authData.userId);
                              },
                            ),
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Text(
                    product.title,
                    style: TextStyle(fontFamily: "Anton", fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    "\$${product.price}",
                    style: TextStyle(fontFamily: "Anton", fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                    onPressed: () {
                      cart.addItem(product.id, product.price, product.title,
                          product.imageUrl);
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Added to cart!"),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                              label: "UNDO!",
                              onPressed: () {
                                cart.removeSingleItem(product.id);
                              })));
                    },
                    child: Text(
                      "Add to chart",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () => Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
        )));
  }
}
