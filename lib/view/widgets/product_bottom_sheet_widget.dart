import 'package:flutter/material.dart';
import 'package:merchant/models/product/product_model.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/provider/report_provider.dart';
import 'package:merchant/view/widgets/global_confirm_button.dart';
import 'package:provider/provider.dart';

class ProductBottomSheetWidget extends StatelessWidget {
  final Product? product;
  const ProductBottomSheetWidget({super.key, required this.product});

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
              const Text("اسم السلعة"),
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
                  const Text("عدد الحبات"),
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
                  const Text("سعر حبة"),
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
                  await pro.addSubProduct(
                    product?.id ?? "",
                    pro.getProductIndex(product?.id) ?? 0,
                    home.nameController.text,
                    int.tryParse(home.priceController.text) ?? 0,
                    int.tryParse(home.countController.text) ?? 0,
                  );
                  // add a buy the report item
                  report.updateReportItem(product?.id ?? "", {
                    "total_bought_count": product?.totalBoughtCount,
                    "total_bought_price": product?.totalBoughtPrice,
                  });
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
