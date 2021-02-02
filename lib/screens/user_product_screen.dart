import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

import '../widgets/app_drawer.dart';
import 'package:flutter/widgets.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user_product";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Product"),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName))
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, AsyncSnapshot snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        child: Consumer<Products>(
                            builder: (ctx, productsData, _) => Padding(
                                  padding: EdgeInsets.all(8),
                                  child: ListView.builder(
                                      itemCount: productsData.items.length,
                                      itemBuilder: (_, int index) => Column(
                                            children: [
                                              UserProductItem(
                                                productsData.items[index].id,
                                                productsData.items[index].title,
                                                productsData
                                                    .items[index].imageUrl,
                                              ),
                                              Divider(),
                                            ],
                                          )),
                                )),
                        onRefresh: () => _refreshProducts(context))));
  }
}
