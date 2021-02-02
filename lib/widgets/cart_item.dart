import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_shop_app/screens/product_detail_screen.dart';

import '../Providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  int quantity;
  final double price;
  final String title;
  final String imageUrl;

  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
    this.imageUrl,
  );

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (dircetion) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text(""),
                  actions: [
                    FlatButton(
                        child: Text("No"),
                        onPressed: () => Navigator.of(context).pop()),
                    FlatButton(
                        child: Text("Yes"),
                        onPressed: () => Navigator.of(context).pop(true)),
                  ],
                ));
      },
      onDismissed: (direction) {
        cart.removeItem(widget.productId);
      },
      child: Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: widget.productId,
                );
              },
              child: Container(
                height: 100,
                width: 100,
                child: Hero(
                  tag: widget.productId,
                  child: FadeInImage(
                    placeholder:
                        AssetImage("assets/images/product-placeholder.png"),
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                      fontFamily: "Anton",
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  "Price per: \$${widget.price}",
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text("Total: \$${widget.price * widget.quantity}",
                    style: TextStyle(color: Colors.black54, fontSize: 16))
              ],
            ),
            Spacer(),
            Column(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_drop_up),
                    onPressed: () {
                      setState(() {
                        widget.quantity++;
                        cart.addSingleItem(widget.productId);
                      });
                    }),
                Text("${widget.quantity.toString()}x"),
                IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        if (widget.quantity == 1) {
                          widget.quantity = widget.quantity;
                        } else {
                          widget.quantity--;
                          cart.removeSingleItem(widget.productId);
                        }
                      });
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
