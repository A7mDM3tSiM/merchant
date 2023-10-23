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
              color: Colors.grey,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            children: [
              SizedBox(height: h * 0.15),
              Text(
                args.product?.name ?? "",
                style: TextStyle(fontSize: h * 0.04),
              ),
              SizedBox(height: h * 0.075),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: w * 0.2,
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
                      children: const [
                        Icon(
                          Icons.add_chart_outlined,
                          color: Colors.blue,
                        ),
                        Text("10000"),
                      ],
                    ),
                  ),
                  Container(
                    width: w * 0.2,
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
                      children: const [
                        Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.green,
                        ),
                        Text("10000"),
                      ],
                    ),
                  ),
                  Container(
                    width: w * 0.2,
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
                      children: const [
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: Colors.amber,
                        ),
                        Text("10000"),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.03),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Sub products',
                  style: TextStyle(fontSize: h * 0.023),
                ),
              ),
              SizedBox(height: h * 0.01),
              SizedBox(
                height: h * 0.45,
                child: Consumer<ProductsProvider>(
                  builder: (_, __, ___) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: args.product?.subProducts.length,
                    itemBuilder: (_, index) {
                      if (args.product != null &&
                          args.product!.subProducts.isNotEmpty) {
                        return SubProductWidget(
                          subProduct: args.product!.subProducts[index],
                        );
                      }
                      return Column(
                        children: [
                          SizedBox(height: h * 0.2),
                          const Center(child: Text("No products")),
                        ],
                      );
                    },
                  ),
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
                child: Icon(
                  home.isBottomSheetOpened
                      ? Icons.arrow_drop_down_outlined
                      : Icons.add,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}