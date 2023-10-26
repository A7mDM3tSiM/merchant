import 'package:merchant/main.dart';
import 'package:merchant/models/report/report_model.dart';
import 'package:merchant/services/firebase_service.dart';

class ReportRepo {
  late final FirebaseService _fb;

  ReportRepo(String? month) {
    final userId = prefs.getString('user_id');
    final currentMonth =
        month ?? "${DateTime.now().month}-${DateTime.now().year}";
    _fb = FirebaseService(collectionPath: "users/$userId/$currentMonth");
  }

  Future<List<ReportItem>> getReport() async {
    final list = <ReportItem>[];

    final reportItemsMapList = await _fb.getCollectionDocs();
    for (final reportItem in reportItemsMapList) {
      list.add(ReportItem.fromMap(reportItem));
    }

    return list;
  }

  Future<String> addReportItem(ReportItem reportItem) async {
    final reportItemId = await _fb.addDoc(reportItem.toMap());
    await _fb.updateDocData(reportItemId, {'id': reportItemId});
    return reportItemId;
  }

  Future<void> updateReportItem(
      String reportItemId, Map<String, dynamic> data) async {
    await _fb.updateDocData(reportItemId, data);
  }
}
