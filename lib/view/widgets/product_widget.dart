import 'package:flutter/material.dart';
import 'package:merchant/components/args/product_view_args.dart';
import 'package:merchant/components/routes/routes.dart';
import 'package:merchant/models/product/product_model.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/services/navigation_service.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () async {
        final home = context.read<HomeProvider>();
        if (home.isBottomSheetOpened) {
          await home.closeBottomSheet();
        }
        NavigationService.push(
          Routes.productRoute,
          arg: ProductViewArgs(product),
        );
      },
      child: Dismissible(
        key: GlobalKey(),
        onDismissed: (_) {
          final pro = context.read<ProductsProvider>();
          pro.deleteProduct(pro.getProductIndex(product.id) ?? 0);
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
              EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
          margin:
              EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_back_ios,
                color: Colors.grey,
              ),
              Text(
                product.name,
                style: TextStyle(
                  fontSize: h * 0.02,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
