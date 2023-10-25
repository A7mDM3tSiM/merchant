import 'package:merchant/main.dart';
import 'package:merchant/models/product/product_model.dart';
import 'package:merchant/services/database_service.dart';
import 'package:merchant/services/firebase_service.dart';

class ProductRepo {
  // ============== Products =====================
  Future<void> addProduct(Product product) async {
    await DatabaseService().insert("products", product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final list = <Product>[];

    final mapData = await DatabaseService().getData("products");
    for (final product in mapData) {
      list.add(Product.fromMap(product));
    }

    return list;
  }

  Future<void> updateProduct(Product product) async {
    await DatabaseService().updateData(
      "products",
      int.tryParse(product.id) ?? 0,
      product.toMap(),
    );
  }

  Future<void> deleteProduct(int id) async {
    await DatabaseService().delete("products", id);
  }

  // SubProducts
  Future<void> addSubProduct(SubProduct subProduct) async {
    await DatabaseService().insert(
      "sub_products",
      subProduct.toMap(),
    );
  }

  Future<List<SubProduct>> getSubProducts() async {
    final list = <SubProduct>[];

    final mapData = await DatabaseService().getData("sub_products");
    for (final product in mapData) {
      list.add(SubProduct.fromMap(product));
    }

    return list;
  }

  Future<void> updateSubProduct(SubProduct subProduct) async {
    await DatabaseService().updateData(
      "sub_products",
      int.tryParse(subProduct.id) ?? 0,
      subProduct.toMap(),
    );
  }

  Future<void> deleteSubProduct(int id) async {
    await DatabaseService().delete("sub_products", id);
  }
}

class ProductRepoFirebase {
  late final FirebaseService _fb;

  ProductRepoFirebase() {
    final id = prefs.getString("user_id");
    _fb = FirebaseService(collectionPath: "users/$id/products");
  }

  // ============== Products =====================
  /// Add the product to the database and return it's path
  Future<String> addProduct(Product product) async {
    // add the product to the database and get the doc path
    final proId = await _fb.addDoc(product.toMap());

    // set the path as the product id and return it
    await _fb.updateDocData(proId, {"id": proId});
    return proId;
  }

  Future<List<Product>> getProducts() async {
    final list = <Product>[];

    // get the products from the database
    final productMapList = await _fb.getCollectionDocs();

    // convert the products from map to Prodcut object
    for (final pro in productMapList) {
      list.add(Product.fromMap(pro));
    }

    return list;
  }

  Future<void> updateProduct(String productId, Product product) async {
    await _fb.updateDocData(productId, product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _fb.deleteDoc(productId);
  }

  // ============== Sub Products =====================
  Future<String> addSubProduct(String parentId, SubProduct subProduct) async {
    final userId = prefs.getString("user_id");
    final fb = FirebaseService(
        collectionPath: "users/$userId/products/$parentId/sub_products");

    // Add the subProduct to the database and get it's doc path
    final subProId = await fb.addDoc(subProduct.toMap());

    // update the doc path to become the subProduct id and return it
    await fb.updateDocData(subProId, {"id": subProId});
    return subProId;
  }

  Future<List<SubProduct>> getSubProducts(String parentId) async {
    final list = <SubProduct>[];
    final userId = prefs.getString("user_id");
    final fb = FirebaseService(
        collectionPath: "users/$userId/products/$parentId/sub_products");

    // get the sub_products from the database
    final subProductMapList = await fb.getCollectionDocs();
    for (final sub in subProductMapList) {
      // convert the sub_products from map to SubProdcut object
      list.add(SubProduct.fromMap(sub));
    }

    return list;
  }

  Future<void> updateSubProduct(String parentId, SubProduct subProdcut) async {
    final userId = prefs.getString("user_id");
    final fb = FirebaseService(
        collectionPath: "users/$userId/products/$parentId/sub_products");

    await fb.updateDocData(subProdcut.id, subProdcut.toMap());
  }

  Future<void> deleteSubProduct(String parentId, String subProductId) async {
    final userId = prefs.getString("user_id");
    final fb = FirebaseService(
        collectionPath: "users/$userId/products/$parentId/sub_products");

    await fb.deleteDoc(subProductId);
  }
}
