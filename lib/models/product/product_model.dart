import '../../main.dart';

class Product {
  late int id;
  String name;

  late String createdAt;
  late String updatedAt;

  final subProducts = <SubProduct>[];

  Product(
    this.name, {
    int? price,
    int? id,
    int? totalBought,
    List<SubProduct>? subProducts,
    String? createdAt,
    String? updatedAt,
  }) {
    this.id = id ?? (prefs.getInt("id_holder") ?? 0) + 1;
    prefs.setInt("id_holder", this.id);

    if (subProducts != null) {
      for (final subProduct in subProducts) {
        this.subProducts.add(subProduct);
      }
    }

    this.createdAt = createdAt ?? DateTime.now().toString();
    this.updatedAt = updatedAt ?? DateTime.now().toString();
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      data['name'] ?? "",
      id: data['id'] ?? 0,
      createdAt: data['created_at'] ?? "",
      updatedAt: data['updated_at'] ?? "",
    );
  }
}

class SubProduct {
  late int id;
  int parentId;
  String name;
  int price;
  int totalBought;

  late int totalSold;
  late int totalSoldPrice;
  late int totalProfit;

  late String createdAt;
  late String updatedAt;

  String get currentCount => (totalBought - totalSold).toString();

  SubProduct(
    this.parentId,
    this.name,
    this.price,
    this.totalBought, {
    int? id,
    int? totalSold,
    int? totalSoldPrice,
    int? totalProfit,
    String? createdAt,
    String? updatedAt,
  }) {
    this.id = id ?? (prefs.getInt("id_holder") ?? 0) + 1;
    prefs.setInt("id_holder", this.id);

    this.totalSold = totalSold ?? 0;
    this.totalSoldPrice = totalSoldPrice ?? 0;
    this.totalProfit = totalProfit ?? 0;

    this.createdAt = createdAt ?? DateTime.now().toString();
    this.updatedAt = updatedAt ?? DateTime.now().toString();
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'parent_id': parentId,
      'name': name,
      'price': price,
      'total_bought': totalBought,
      'total_sold': totalSold,
      'total_sold_price': totalSoldPrice,
      'total_profit': totalProfit,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory SubProduct.fromMap(Map<String, dynamic> data) {
    return SubProduct(
      data['parent_id'] ?? 0,
      data['name'] ?? "",
      data['price'] ?? 0,
      data['total_bought'] ?? 0,
      id: data['id'] ?? 0,
      totalSold: data['total_sold'] ?? 0,
      totalSoldPrice: data['total_sold_price'] ?? 0,
      totalProfit: data['total_profit'] ?? 0,
      createdAt: data['created_at'] ?? "",
      updatedAt: data['updated_at'] ?? "",
    );
  }

  void buy(int count) {
    totalBought = totalBought + count;
  }

  void sell(int count, int price) {
    totalSold = totalSold + count;
    totalSoldPrice = totalSoldPrice + (count * price);
    setProfit();
  }

  void setProfit() {
    totalProfit = (totalBought * price) - totalSoldPrice;
  }
}
