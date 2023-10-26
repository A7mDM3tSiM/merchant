class ReportItem {
  String? id;
  String productId;
  String name;
  int totalBoughtCount;
  int totalSoldCount;
  int totalBoughtPrice;
  int totalSoldPrice;

  ReportItem({
    this.id,
    required this.productId,
    required this.name,
    required this.totalBoughtCount,
    required this.totalBoughtPrice,
    required this.totalSoldCount,
    required this.totalSoldPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      "product_id": productId,
      "name": name,
      "total_bought_count": totalBoughtCount,
      "total_bought_price": totalBoughtPrice,
      "total_sold_count": totalSoldCount,
      "total_sold_price": totalSoldPrice,
    };
  }

  factory ReportItem.fromMap(Map<String, dynamic>? data) {
    return ReportItem(
      id: data?['id'],
      name: data?['name'],
      productId: data?['product_id'],
      totalBoughtCount: data?['total_bought_count'],
      totalBoughtPrice: data?['total_bought_price'],
      totalSoldCount: data?['total_sold_count'],
      totalSoldPrice: data?['total_sold_price'],
    );
  }
}
