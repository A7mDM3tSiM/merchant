class Product {
  late String id;
  String name;

  late String createdAt;
  late String updatedAt;

  final subProducts = <SubProduct>[];

  set setId(String id) => this.id = id;

  int get totalCurrentCount {
    var total = 0;
    for (final sub in subProducts) {
      total = total + (sub.totalBought - sub.totalSold);
    }
    return total;
  }

  int get totalBoughtCount {
    var total = 0;
    for (final sub in subProducts) {
      total = total + sub.totalBought;
    }
    return total;
  }

  int get totalSoldCount {
    var total = 0;
    for (final sub in subProducts) {
      total = total + sub.totalSold;
    }
    return total;
  }

  int get totalBoughtPrice {
    var total = 0;
    for (final sub in subProducts) {
      total = total + (sub.totalBought * sub.price);
    }
    return total;
  }

  int get totalSoldPrice {
    var total = 0;
    for (final sub in subProducts) {
      total = total + sub.totalSoldPrice;
    }
    return total;
  }

  int get totalProfit {
    var total = 0;
    for (final sub in subProducts) {
      total = total + sub.totalProfit;
    }
    return total;
  }

  Product(
    this.name, {
    int? price,
    String? id,
    int? totalBought,
    List<SubProduct>? subProducts,
    String? createdAt,
    String? updatedAt,
  }) {
    if (id != null) {
      this.id = id;
    }

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
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Product.fromMap(Map<String, dynamic>? data) {
    return Product(
      data?['name'] ?? "",
      id: data?['id'] ?? "",
      createdAt: data?['created_at'] ?? "",
      updatedAt: data?['updated_at'] ?? "",
    );
  }
}

class SubProduct {
  late String id;
  String parentId;
  String name;
  int price;
  int totalBought;

  late int totalSold;
  late int totalSoldPrice;
  late int totalProfit;

  late String createdAt;
  late String updatedAt;

  String get currentCount => (totalBought - totalSold).toString();

  set setId(String id) => this.id = id;

  SubProduct(
    this.parentId,
    this.name,
    this.price,
    this.totalBought, {
    String? id,
    int? totalSold,
    int? totalSoldPrice,
    int? totalProfit,
    String? createdAt,
    String? updatedAt,
  }) {
    if (id != null) {
      this.id = id;
    }

    this.totalSold = totalSold ?? 0;
    this.totalSoldPrice = totalSoldPrice ?? 0;
    this.totalProfit = totalProfit ?? 0;

    this.createdAt = createdAt ?? DateTime.now().toString();
    this.updatedAt = updatedAt ?? DateTime.now().toString();

    setProfit();
  }

  Map<String, Object?> toMap() {
    return {
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

  factory SubProduct.fromMap(Map<String, dynamic>? data) {
    return SubProduct(
      data?['parent_id'] ?? 0,
      data?['name'] ?? "",
      data?['price'] ?? 0,
      data?['total_bought'] ?? 0,
      id: data?['id'] ?? "",
      totalSold: data?['total_sold'] ?? 0,
      totalSoldPrice: data?['total_sold_price'] ?? 0,
      totalProfit: data?['total_profit'] ?? 0,
      createdAt: data?['created_at'] ?? "",
      updatedAt: data?['updated_at'] ?? "",
    );
  }

  void buy(int count) {
    totalBought = totalBought + count;
    setProfit();
  }

  void sell(int count, int price) {
    if (count <= (int.tryParse(currentCount) ?? 0)) {
      totalSold = totalSold + count;
      totalSoldPrice = totalSoldPrice + (count * price);
      setProfit();
    } else {
      throw Exception(302);
    }
  }

  void setProfit() {
    totalProfit = totalSoldPrice - (totalBought * price);
  }
}
