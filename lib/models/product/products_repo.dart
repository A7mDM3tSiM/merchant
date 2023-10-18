import 'package:merchant/models/product/product_model.dart';
import 'package:merchant/services/database_service.dart';

class ProductRepo {
  // Products
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
      product.id,
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
      subProduct.id,
      subProduct.toMap(),
    );
  }

  Future<void> deleteSubProduct(int id) async {
    await DatabaseService().delete("sub_products", id);
  }
}
