import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merchant/models/product/products_repo.dart';
import 'package:merchant/provider/report_provider.dart';
import 'package:merchant/services/navigation_service.dart';
import 'package:provider/provider.dart';

import '../models/product/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  final _repo = ProductRepoFirebase();
  var isLoading = false;
  var isSettingNewReport = false;

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

  Product getProductById(String id) {
    return _products.where((e) => e.id == id).first;
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
    _products.addAll(products.reversed);
  }

  Future<String> addProduct(
    String name, {
    int? price,
    int? totalBought,
  }) async {
    startLoading();
    late final String? proId;
    final newProduct = Product(name, price: price, totalBought: totalBought);
    try {
      // add the product to the database and get it's path to assign as an Id
      proId = await _repo.addProduct(newProduct);

      // assign the path as id and add the product to current products list
      newProduct.setId = proId;
      _products.add(newProduct);
    } on Exception catch (e) {
      debugPrint('$e');
    }

    await addSubProduct(newProduct.id, _products.indexOf(newProduct), name,
        price ?? 0, totalBought ?? 0);

    return proId ?? "";
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
      // add the subProduct to the database and get it's path to assign it as id
      final subProId = await _repo.addSubProduct(parentId, newSubProduct);

      // assign the path as Id and add the subProduct to current products list
      newSubProduct.setId = subProId;
      _products[parentIndex].subProducts.add(newSubProduct);

      // Notify of product added
      Fluttertoast.showToast(
        msg: "تمت اضافة منتج جديد",
        backgroundColor: Colors.green,
        fontSize: 20,
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
        msg: "تمت اضافة منتج جديد",
        backgroundColor: Colors.green,
        fontSize: 20,
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
        msg: "نم بيع المنتج",
        backgroundColor: Colors.green,
        fontSize: 20,
      );
    } on Exception catch (e) {
      debugPrint('$e');
      if (e.toString().contains("302")) {
        // Notify of amount excceded
        Fluttertoast.showToast(
          msg: "تجاوزت عدد المنتجات الذي تملكه",
          backgroundColor: Colors.red,
          fontSize: 20,
        );
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
      await _repo.deleteProduct(id);

      // Notify of product delete
      Fluttertoast.showToast(
        msg: "تم حذف المنتح",
        backgroundColor: Colors.green,
        fontSize: 20,
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
          msg: "تم حذف المنتح",
          backgroundColor: Colors.green,
          fontSize: 20,
        );
      }
    } on Exception catch (e) {
      debugPrint('$e');
    }
    stopLoading();
  }

  Future<void> setNewMonthReport() async {
    final context = NavigationService.navKey.currentContext!;
    final report = context.read<ReportProvider>();

    if (!await report.isNewMonthReportSet()) {
      isSettingNewReport = true;
      notifyListeners();

      for (final pro in _products) {
        await report.addReportItem(
          productId: pro.id,
          name: pro.name,
          totalBoughtCount: 0,
          totalBoughtPrice: 0,
          totalSoldCount: 0,
          totalSoldPrice: 0,
        );
      }
    }

    isSettingNewReport = false;
    notifyListeners();
  }
}
