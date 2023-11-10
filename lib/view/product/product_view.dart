import 'package:flutter/material.dart';
import 'package:merchant/components/args/product_view_args.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/services/navigation_service.dart';
import 'package:merchant/view/widgets/sub_product_widget.dart';
import 'package:provider/provider.dart';

import '../../provider/home_provider.dart';
import '../widgets/product_bottom_sheet_widget.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ProductViewArgs;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        final home = context.read<HomeProvider>();
        if (home.isBottomSheetOpened) {
          await home.closeBottomSheet();
        } else {
          NavigationService.pop();
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () async {
              final home = context.read<HomeProvider>();
              if (home.isBottomSheetOpened) {
                await home.closeBottomSheet();
              }
              NavigationService.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.025),
          child: Column(
            children: [
              SizedBox(height: h * 0.1),
              Text(
                args.product?.name ?? "",
                style: TextStyle(fontSize: h * 0.04),
              ),
              SizedBox(height: h * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<ProductsProvider>(
                    builder: (_, __, ___) => Text(
                      args.product?.totalCurrentCount.toString() ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: h * 0.018,
                      ),
                    ),
                  ),
                  Text(
                    ' :العدد الكلي',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: h * 0.018,
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(h * 0.005),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_chart_outlined,
                          color: Colors.blue,
                        ),
                        Consumer<ProductsProvider>(
                          builder: (_, __, ___) => Text(
                            args.product?.totalProfit.toString() ?? "",
                            style: TextStyle(
                              fontSize: h * 0.018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(h * 0.005),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.green,
                        ),
                        Consumer<ProductsProvider>(
                          builder: (_, __, ___) => Text(
                            args.product?.totalSoldPrice.toString() ?? "",
                            style: TextStyle(
                              fontSize: h * 0.018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(h * 0.005),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.amber,
                        ),
                        Consumer<ProductsProvider>(
                          builder: (_, __, ___) => Text(
                            args.product?.totalBoughtPrice.toString() ?? "",
                            style: TextStyle(
                              fontSize: h * 0.018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.03),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'السلع',
                  style: TextStyle(fontSize: h * 0.023),
                ),
              ),
              SizedBox(height: h * 0.01),
              SizedBox(
                height: h * 0.525,
                child: Consumer<ProductsProvider>(
                  builder: (_, pro, ___) {
                    if (pro.isLoading) {
                      return Column(
                        children: [
                          SizedBox(height: h * 0.2),
                          const CircularProgressIndicator(),
                        ],
                      );
                    }
                    if (args.product != null &&
                        args.product!.subProducts.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(height: h * 0.2),
                          Center(
                            child: Text(
                              "لا توجد منتجات",
                              style: TextStyle(
                                fontSize: h * 0.023,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: args.product?.subProducts.length,
                      itemBuilder: (_, index) => SubProductWidget(
                        subProduct: args.product!.subProducts[index],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Consumer<HomeProvider>(
          builder: (_, home, __) => Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  if (home.controller != null) {
                    home.closeBottomSheet();
                  } else {
                    home.openBottomSheet();
                    home.controller = showBottomSheet(
                      context: context,
                      enableDrag: false,
                      builder: (context) => ProductBottomSheetWidget(
                        product: args.product,
                      ),
                    );
                  }
                },
                backgroundColor: Colors.white,
                child: Icon(
                  home.isBottomSheetOpened
                      ? Icons.arrow_drop_down_outlined
                      : Icons.add,
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
