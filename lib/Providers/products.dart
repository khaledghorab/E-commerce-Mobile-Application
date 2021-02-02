import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Nike Flat Shoes',
    //   description: 'The Air Jordan 1 Mid “Light Smoke Grey” Is Available Now The Air Jordan 1 Mid “Light Smoke Grey” Is Available Now The Air Jordan 1 Mid “Light Smoke Grey” Is Available Now The Air Jordan 1 Mid “Light Smoke Grey” Is Available Now',
    //   price: 196.99,
    //   imageUrl:
    //   'https://stockx-360.imgix.net/Air-Jordan-1-Mid-Light-Smoke-Grey/Images/Air-Jordan-1-Mid-Light-Smoke-Grey/Lv2/img01.jpg?auto=format,compress&q=90&updated_at=1606319491&w=1000',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Light Blue Tee',
    //   description: 'Heather Gray 90% cotton/10% polyester; Fabric laundered',
    //   price:  26.99,
    //   imageUrl:
    //   'https://iheartdogs.com/wp-content/uploads/2019/06/redirect-6.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'WatchTime',
    //   description: 'This watch is made of platinum and has a strong gloss finish.',
    //   price: 209.99,
    //   imageUrl:
    //   'https://static.watchtime.com/wp-content/uploads/2017/09/Ulysse_Nardin_Executive_Moonstruck_Worldtimer_RG_front_1000.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String authToken;
  String userId;

  getData(String authTokenC, String userIdC, List<Product> products) {
    authToken = authTokenC;
    userId = userIdC;
    _items = products;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favourietItems {
    return items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredString =
    filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url =
        "https://shop-a4080-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filteredString";

    try {
      final res = await http.get(url);
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      url =
      "https://shop-a4080-default-rtdb.firebaseio.com/userFavourites/$userId.json?auth=$authToken";
      final favRes = await http.get(url);
      final favData = json.decode(favRes.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData["title"],
            description: prodData["description"],
            price: prodData["price"],
            imageUrl: prodData["imageUrl"],
            isFavourite: favData == null ? false : favData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://shop-a4080-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final res = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "creatorId": userId
          }));
      final newProduct = Product(
        id: json.decode(res.body)["name"],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          "https://shop-a4080-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("....");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shop-a4080-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete Product.");
    }
    existingProduct = null;
  }
}
