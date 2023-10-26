import 'package:flutter/material.dart';
import 'package:merchant/provider/report_provider.dart';
import 'package:merchant/view/widgets/report_item_widget.dart';
import 'package:provider/provider.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final report = context.read<ReportProvider>();
      report.fetchReport(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2050),
                        locale: const Locale('ar'),
                        builder: (_, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.black,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            child: child!),
                      ).then((date) {
                        if (date != null) {
                          final report = context.read<ReportProvider>();
                          report.fetchReport("${date.month}-${date.year}");
                        }
                      });
                    },
                    child: Consumer<ReportProvider>(
                      builder: (_, report, __) => Text(
                        report.currentMonth,
                        style: TextStyle(
                          fontSize: h * 0.023,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "التقرير الشهري",
                    style: TextStyle(
                      fontSize: h * 0.023,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.025),
            Consumer<ReportProvider>(builder: (_, report, __) {
              if (report.isLoading) {
                return Column(
                  children: [
                    SizedBox(height: h * 0.45),
                    const Center(child: CircularProgressIndicator()),
                  ],
                );
              }
              if (report.report.isEmpty) {
                return Column(
                  children: [
                    SizedBox(height: h * 0.45),
                    const Center(
                      child: Text("لا توجد منتجات"),
                    ),
                  ],
                );
              }
              return SizedBox(
                height: h * 0.8,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: report.report.length,
                  itemBuilder: (_, index) => ReportItemWidget(
                    reportItem: report.report[index],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
