import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merchant/models/product/products_repo.dart';

import '../models/product/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  final _repo = ProductRepoFirebase();
  var isLoading = false;

  final _products = <Product>[];
  List<Product> get products => _products;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  int? getProductIndex(String? id) {
    if (id == null) return null;
    return _products.indexWhere((pro) => pro.id == id);
  }

  int? getSubProductIndex(String? parentId, String? id) {
    if (parentId == null || id == null) return null;
    final parent = _products[getProductIndex(parentId) ?? 0];

    return parent.subProducts.indexWhere((sub) => sub.id == id);
  }

  List<Product> listToShow(String search) {
    search = search.trim();
    if (search.isEmpty) {
      return _products;
    }

    final list = <Product>[];

    for (final pro in products) {
      if (pro.name.contains(search)) {
        list.add(pro);
      }
    }

    return list;
  }

  /// Get the products when the app starts and use [assignSubProductsToProducts]
  /// to filter the products and add subProducts to each product
  Future<void> fecthProducts() async {
    startLoading();

    try {
      final products = await _repo.getProducts();
      await assignSubProductsToProducts(products);
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }

  Future<void> assignSubProductsToProducts(List<Product> products) async {
    for (final product in products) {
      final subPro = await _repo.getSubProducts(product.id);
      product.subProducts.addAll(subPro);
    }

    _products.clear();
    _products.addAll(products);
  }

  Future<void> addProduct(
    String name, {
    int? price,
    int? totalBought,
  }) async {
    startLoading();

    final newProduct = Product(name, price: price, totalBought: totalBought);
    try {
      // add the product to current products list
      _products.add(newProduct);

      // add the product to the database
      await _repo.addProduct(newProduct);
    } on Exception catch (e) {
      debugPrint('$e');
    }

    addSubProduct(
      newProduct.id,
      _products.indexOf(newProduct),
      name,
      price ?? 0,
      totalBought ?? 0,
    );
    stopLoading();
  }

  Future<void> addSubProduct(
    String parentId,
    int parentIndex,
    String name,
    int price,
    int totalBought,
  ) async {
    startLoading();

    final newSubProduct = SubProduct(parentId, name, price, totalBought);

    try {
      // add the subProduct to current products list
      _products[parentIndex].subProducts.add(newSubProduct);

      // add the subProduct to the database
      await _repo.addSubProduct(parentId, newSubProduct);

      // Notify of product added
      Fluttertoast.showToast(
        msg: "New product added",
        backgroundColor: Colors.green,
      );
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }

  Future<void> buySubProduct(
      int productIndex, int subProductIndex, int count) async {
    startLoading();

    try {
      // edit the subProduct in the products list
      _products[productIndex].subProducts[subProductIndex].buy(count);

      // edit the subproduct in the database
      await _repo.updateSubProduct(
        _products[productIndex].id,
        _products[productIndex].subProducts[subProductIndex],
      );
      // Notify of product bought
      Fluttertoast.showToast(
        msg: "New product added",
        backgroundColor: Colors.green,
      );
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }

  Future<void> sellSubProduct(
      int productIndex, int subProductIndex, int count, int price) async {
    startLoading();

    try {
      // edit the subProduct in the products list
      _products[productIndex].subProducts[subProductIndex].sell(count, price);

      // edit the subproduct in the database
      await _repo.updateSubProduct(
        _products[productIndex].id,
        _products[productIndex].subProducts[subProductIndex],
      );

      // Notify of product sold
      Fluttertoast.showToast(
        msg: "Product sold",
        backgroundColor: Colors.green,
      );
    } on Exception catch (e) {
      debugPrint('$e');
      if (e.toString().contains("302")) {
        // Notify of amount excceded
        Fluttertoast.showToast(
          msg: "Excceded product available amount",
          backgroundColor: Colors.red,
        );
      }
    }
    stopLoading();
  }

  Future<void> deleteProduct(int productIndex) async {
    startLoading();
    final id = _products[productIndex].id;

    try {
      // delete all subProducts from the database
      for (var i = 0; i <= _products[productIndex].subProducts.length; i++) {
        await deleteSubProduct(productIndex, i, isAfterProductDelete: true);
      }

      // delete from the products list
      _products.removeAt(productIndex);

      // delete from the database
      _repo.deleteProduct(id);

      // Notify of product delete
      Fluttertoast.showToast(
        msg: "Product deleted",
        backgroundColor: Colors.green,
      );
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }

  Future<void> deleteSubProduct(
    int productIndex,
    int subProductIndex, {
    bool isAfterProductDelete = false,
  }) async {
    startLoading();
    final id = _products[productIndex].subProducts[subProductIndex].id;

    try {
      // delete the subProduct in the products list
      _products[productIndex].subProducts.removeAt(subProductIndex);

      // delete the subproduct in the database
      await _repo.deleteSubProduct(_products[productIndex].id, id);

      // Notify of subProduct delete if isAfterProductDelete = false
      if (!isAfterProductDelete) {
        Fluttertoast.showToast(
          msg: "Product deleted",
          backgroundColor: Colors.green,
        );
      }
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }
}
