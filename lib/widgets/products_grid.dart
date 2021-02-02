import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final productData = Provider.of<Products>(context);
    final products =
        showFavs ? productData.favourietItems : productData.items;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:products.isEmpty? Center(child: Text("There is no producst!"),):GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio:isLandscape ?1.65/1: 3 / 4,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: products[index],
                child: ProductItem(),
              )),
    );
  }
}
