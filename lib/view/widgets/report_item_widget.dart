import 'package:flutter/material.dart';
import 'package:merchant/models/report/report_model.dart';

class ReportItemWidget extends StatelessWidget {
  final ReportItem reportItem;
  const ReportItemWidget({super.key, required this.reportItem});

  @override
  Widget build(BuildContext context) {
    int profit() {
      return (reportItem.totalSoldPrice - reportItem.totalBoughtPrice);
    }

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: h * 0.01),
      margin: EdgeInsets.symmetric(horizontal: w * 0.015, vertical: h * 0.01),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            reportItem.name,
            style: TextStyle(
              fontSize: h * 0.023,
              color: Colors.black,
            ),
          ),
          SizedBox(height: h * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Income"),
                  Text(reportItem.totalBoughtCount.toString()),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Outcome"),
                  Text(reportItem.totalSoldCount.toString()),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Income cost"),
                  Text(reportItem.totalBoughtPrice.toString()),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Outcome cost"),
                  Text(reportItem.totalSoldPrice.toString()),
                ],
              ),
            ],
          ),
          SizedBox(height: h * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Profits: ${profit().toString()}"),
            ],
          ),
          SizedBox(height: h * 0.01),
        ],
      ),
    );
  }
}
