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

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2023),
              lastDate: DateTime(2050),
              locale: const Locale("ar"),
              initialEntryMode: DatePickerEntryMode.calendarOnly,
              initialDatePickerMode: DatePickerMode.day,
            ).then((date) {
              final report = context.read<ReportProvider>();
              report.fetchReport("${date?.month}-${date?.year}");
            });
          },
          child: Consumer<ReportProvider>(
            builder: (_, report, __) => Text(
              report.currentMonth,
            ),
          ),
        ),
      ),
      body: Consumer<ReportProvider>(builder: (_, report, __) {
        if (report.isLoading) {
          return Column(
            children: [
              SizedBox(height: h * 0.45),
              const CircularProgressIndicator(),
            ],
          );
        }
        if (report.report.isEmpty) {
          return Column(
            children: [
              SizedBox(height: h * 0.45),
              const Center(
                child: Text("No products"),
              ),
            ],
          );
        }
        return ListView.builder(
          itemBuilder: (_, index) => ReportItemWidget(
            reportItem: report.report[index],
          ),
        );
      }),
    );
  }
}
