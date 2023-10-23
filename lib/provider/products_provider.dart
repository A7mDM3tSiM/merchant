import 'package:flutter/material.dart';
import 'package:merchant/models/product/products_repo.dart';

import '../models/product/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  final _repo = ProductRepo();
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

  int? getProductIndex(int? id) {
    if (id == null) return null;
    return _products.indexWhere((pro) => pro.id == id);
  }

  int? getSubProductIndex(int? parentId, int? id) {
    if (parentId == null || id == null) return null;
    final parent = _products[getProductIndex(parentId) ?? 0];

    return parent.subProducts.indexWhere((sub) => sub.id == id);
  }

  /// Get the products when the app starts and use [assignSubProductsToProducts]
  /// to filter the products and add subProducts to each product
  Future<void> fecthProducts() async {
    startLoading();

    try {
      final products = await _repo.getProducts();
      final subProducts = await _repo.getSubProducts();
      assignSubProductsToProducts(products, subProducts);
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }

  void assignSubProductsToProducts(
      List<Product> products, List<SubProduct> subs) {
    for (final product in products) {
      for (final subP in subs) {
        if (product.id == subP.parentId) {
          product.subProducts.add(subP);
        }
      }
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

    addSubProduct(newProduct.id, _products.indexOf(newProduct), name,
        price ?? 0, totalBought ?? 0);
    stopLoading();
  }

  Future<void> addSubProduct(
    int parentId,
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
      await _repo.addSubProduct(newSubProduct);

      // TODO: Notify of product added
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
        _products[productIndex].subProducts[subProductIndex],
      );
      // TODO: Notify of product bought
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
        _products[productIndex].subProducts[subProductIndex],
      );

      // TODO: Notify of product sold
    } on Exception catch (e) {
      debugPrint('$e');
      if (e.toString().contains("302")) {
        // TODO: Notify of amount excceded
      }
    }
    stopLoading();
  }

  Future<void> deleteProduct(int productIndex) async {
    startLoading();
    final id = _products[productIndex].id;

    try {
      // delete from the products list
      _products.removeAt(productIndex);

      // delete from the database
      _repo.deleteProduct(id);
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }

  Future<void> deleteSubProduct(int productIndex, int subProductIndex) async {
    startLoading();
    final id = _products[productIndex].subProducts[subProductIndex].id;

    try {
      // delete the subProduct in the products list
      _products[productIndex].subProducts.removeAt(subProductIndex);

      // delete the subproduct in the database
      await _repo.deleteSubProduct(id);
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }
}
