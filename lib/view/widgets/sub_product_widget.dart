import 'dart:math';

import 'package:flutter/material.dart';
import 'package:merchant/models/product/product_model.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/view/widgets/buy_bottom_sheet_widget.dart';
import 'package:merchant/view/widgets/sell_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/products_provider.dart';

class SubProductWidget extends StatelessWidget {
  final SubProduct subProduct;
  const SubProductWidget({super.key, required this.subProduct});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Dismissible(
      key: GlobalKey(),
      onDismissed: (_) {
        final pro = context.read<ProductsProvider>();
        pro.deleteSubProduct(
          pro.getProductIndex(subProduct.parentId) ?? 0,
          pro.getSubProductIndex(subProduct.parentId, subProduct.id) ?? 0,
        );
      },
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.015),
        margin: EdgeInsets.symmetric(vertical: h * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: w * 0.3,
              child: Row(
                children: [
                  Consumer<HomeProvider>(
                    builder: (_, home, __) => GestureDetector(
                      onTap: () {
                        if (home.controller != null) {
                          home.closeBottomSheet();
                        } else {
                          home.nameController.text = subProduct.name;
                          home.priceController.text =
                              subProduct.price.toString();
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
                      child: const Icon(
                        Icons.download,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                  Transform.rotate(
                    angle: pi,
                    child: Consumer<HomeProvider>(
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
                        child: const Icon(
                          Icons.download,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.025),
                  Text(
                    "${subProduct.currentCount} حبة",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: h * 0.017,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${subProduct.price.toString()} ج",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: h * 0.017,
                    ),
                  ),
                  Text(
                    subProduct.name,
                    style: TextStyle(
                      fontSize: h * 0.018,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
