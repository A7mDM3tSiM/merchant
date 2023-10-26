import 'package:flutter/material.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/provider/report_provider.dart';
import 'package:merchant/view/widgets/global_confirm_button.dart';
import 'package:provider/provider.dart';

class HomeBottomSheetWidget extends StatelessWidget {
  const HomeBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: h * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<HomeProvider>(
                builder: (_, home, __) => Container(
                  width: w * 0.7,
                  decoration: const BoxDecoration(
                    border: BorderDirectional(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  child: TextField(
                    controller: home.nameController,
                    keyboardType: TextInputType.name,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              SizedBox(width: w * 0.05),
              Text(
                "اسم السلعة",
                style: TextStyle(
                  fontSize: h * 0.017,
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<HomeProvider>(
                    builder: (_, home, __) => Container(
                      width: w * 0.2,
                      decoration: const BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: home.countController,
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.05),
                  Text(
                    "عدد الحبات",
                    style: TextStyle(
                      fontSize: h * 0.017,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<HomeProvider>(
                    builder: (_, home, __) => Container(
                      width: w * 0.2,
                      decoration: const BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: home.priceController,
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.05),
                  Text(
                    "سعر حبة",
                    style: TextStyle(
                      fontSize: h * 0.017,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: h * 0.03),
          ConfirmButton(
            onTap: () async {
              final pro = context.read<ProductsProvider>();
              final home = context.read<HomeProvider>();
              final report = context.read<ReportProvider>();

              if (!pro.isLoading) {
                if (home.isAllFieldsFilled()) {
                  FocusManager.instance.primaryFocus?.unfocus();

                  final price = int.tryParse(home.priceController.text) ?? 0;
                  final totalBought =
                      int.tryParse(home.countController.text) ?? 0;
                  final proId = await pro.addProduct(
                    home.nameController.text,
                    price: int.tryParse(home.priceController.text),
                    totalBought: int.tryParse(home.countController.text),
                  );
                  report.addReportItem(
                    productId: proId,
                    name: pro.getProductById(proId).name,
                    totalBoughtCount: totalBought,
                    totalBoughtPrice: (totalBought * price),
                    totalSoldCount: 0,
                    totalSoldPrice: 0,
                  );
                  home.closeBottomSheet();
                }
              }
            },
          ),
          SizedBox(height: h * 0.03),
        ],
      ),
    );
  }
}
