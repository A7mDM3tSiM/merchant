import 'package:flutter/material.dart';
import 'package:merchant/models/report/report_model.dart';
import 'package:merchant/models/report/report_repo.dart';

class ReportProvider extends ChangeNotifier {
  final _report = <ReportItem>[];
  List<ReportItem> get report => _report;

  var currentMonth = "";
  var isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchReport(String? month) async {
    currentMonth = month ?? "${DateTime.now().month}-${DateTime.now().year}";
    startLoading();

    final reportRepo = ReportRepo(month);
    final report = await reportRepo.getReport();
    _report.addAll(report);

    stopLoading();
  }

  Future<void> addReportItem({
    required String productId,
    required String name,
    required int totalBoughtCount,
    required int totalBoughtPrice,
    required int totalSoldCount,
    required int totalSoldPrice,
  }) async {
    final newReportItem = ReportItem(
      productId: productId,
      name: name,
      totalBoughtCount: totalBoughtCount,
      totalBoughtPrice: totalBoughtPrice,
      totalSoldCount: totalSoldCount,
      totalSoldPrice: totalSoldPrice,
    );

    // passing null to the reportRepo class means using the current month
    final reportRepo = ReportRepo(null);
    await reportRepo.addReportItem(newReportItem);
  }

  Future<void> updateReportItem(
      String productId, Map<String, dynamic> data) async {
    final reportRepo = ReportRepo(null);
    final reportItemId = await _getReportItemIdByProductId(productId) ?? "";
    await reportRepo.updateReportItem(reportItemId, data);
  }

  Future<String?> _getReportItemIdByProductId(String id) async {
    await fetchReport(null);
    return _report.where((e) => e.productId == id).first.id;
  }
}
