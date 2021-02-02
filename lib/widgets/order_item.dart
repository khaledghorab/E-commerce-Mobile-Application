import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../Providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  OrderItem(this.order);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text("\$${order.amount}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            )),
        subtitle: Text(DateFormat("dd/MM/yyyy hh:mm").format(order.dateTime),
            style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w800)),
        children: order.products
            .map(
              (product) => ListTile(
                title: Text(
                  product.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${product.quantity}x\$${product.price}",
                  style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                ),
                trailing: Text("\$${product.quantity * product.price}",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ),
            )
            .toList(),
      ),
    );
  }
}
