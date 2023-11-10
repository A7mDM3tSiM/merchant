import 'package:flutter/material.dart';
import 'package:merchant/models/product/product_model.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/view/widgets/buy_bottom_sheet_widget.dart';
import 'package:merchant/view/widgets/sell_bottom_sheet_widget.dart';
import 'package:merchant/view/widgets/sure_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/products_provider.dart';

class SubProductWidget extends StatelessWidget {
  final SubProduct subProduct;
  const SubProductWidget({super.key, required this.subProduct});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    String toShortString(String str) {
      if (str.length > 23) {
        return "${str.substring(0, 23)}...";
      } else {
        return str;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.015),
      margin: EdgeInsets.symmetric(vertical: h * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "السعر : ${subProduct.price.toString()} ج",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: h * 0.017,
                        ),
                      ),
                      Text(
                        "العدد : ${subProduct.currentCount}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: h * 0.017,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: w * 0.45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        toShortString(subProduct.name),
                        style: TextStyle(
                          fontSize: h * 0.018,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog<bool>(
                            context: context,
                            builder: (_) => const SureWidget(),
                          ).then(
                            (value) {
                              if (value != null) {
                                if (value) {
                                  final pro = context.read<ProductsProvider>();
                                  pro.deleteSubProduct(
                                    pro.getProductIndex(subProduct.parentId) ??
                                        0,
                                    pro.getSubProductIndex(subProduct.parentId,
                                            subProduct.id) ??
                                        0,
                                  );
                                }
                              }
                            },
                          );
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: h * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Consumer<HomeProvider>(
                builder: (_, home, __) => GestureDetector(
                  onTap: () {
                    if (home.controller != null) {
                      home.closeBottomSheet();
                    } else {
                      home.nameController.text = subProduct.name;
                      home.priceController.text = subProduct.price.toString();
                      home.openBottomSheet();
                      home.controller = showBottomSheet(
                        context: context,
                        enableDrag: false,
                        builder: (context) => BuyBottomSheetWidget(
                          subProduct: subProduct,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "شراء",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: h * 0.02,
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: h * 0.025,
                color: Colors.grey,
              ),
              Consumer<HomeProvider>(
                builder: (_, home, __) => GestureDetector(
                  onTap: () {
                    if (home.controller != null) {
                      home.closeBottomSheet();
                    } else {
                      home.nameController.text = subProduct.name;
                      home.openBottomSheet();
                      home.controller = showBottomSheet(
                        context: context,
                        enableDrag: false,
                        builder: (context) => SellBottomSheetWidget(
                          subProduct: subProduct,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "بيع",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: h * 0.02,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
