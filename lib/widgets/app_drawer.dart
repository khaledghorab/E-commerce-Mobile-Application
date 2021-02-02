import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../Providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
                title: Text("Hello Friends"), automaticallyImplyLeading: false),
            buildListTile(Icons.shop, "Shop",
                () => Navigator.of(context).pushReplacementNamed("/")),
            Divider(),
            buildListTile(
                Icons.payment,
                "Orders",
                () => Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName)),
            Divider(),
            buildListTile(
                Icons.edit,
                "Manage Product",
                () => Navigator.of(context)
                    .pushReplacementNamed(UserProductScreen.routeName)),
            Divider(),
            buildListTile(Icons.exit_to_app, "Logout", () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logout();
            })
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(IconData icon, String text, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
