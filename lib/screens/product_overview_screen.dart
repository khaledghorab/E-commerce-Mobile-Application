import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/cart.dart';
import '../Providers/products.dart';
import 'package:real_shop_app/widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import './cart_screen.dart';

enum FilterOption { Favourite, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavourite = false;
Products product;
  @override
  void initState() {
    _isLoading = true;
     Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() => _isLoading = false))
        .catchError((error) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text("Only Favourites"),
                  value: FilterOption.Favourite),
              PopupMenuItem(
                child: Text("All"),
                value: FilterOption.All,
              ),
            ],
            onSelected: (FilterOption selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.Favourite)
                  _showOnlyFavourite = true;
                else
                  _showOnlyFavourite = false;
              });
            },
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(CartScreen.routeName)),
              builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cart.itemCount.toString(),
                    color: Colors.lightGreen,
                  ))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showOnlyFavourite),
      drawer: AppDrawer(),
    );
  }
}
