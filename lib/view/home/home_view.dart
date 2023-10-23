import 'package:flutter/material.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/view/widgets/product_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/home_bottom_sheet_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Market Name",
          style: TextStyle(fontSize: h * 0.023),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: h * 0.025,
          ),
          SizedBox(
            width: w,
            height: h * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.filter_list,
                  color: Colors.grey,
                ),
                SizedBox(width: w * 0.05),
                Container(
                  width: w * 0.85,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.03),
                      const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: h * 0.05,
          ),
          Consumer<ProductsProvider>(
            builder: (_, pro, __) {
              if (pro.isLoading) {
                return Column(
                  children: [
                    SizedBox(height: h * 0.3),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }
              if (pro.products.isEmpty) {
                return Column(
                  children: [
                    SizedBox(height: h * 0.3),
                    const Center(
                      child: Text("No products"),
                    ),
                  ],
                );
              }
              return SizedBox(
                height: h * 0.7,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: pro.products.length,
                  itemBuilder: (context, index) => ProductWidget(
                    product: pro.products[index],
                  ),
                ),
              );
            },
          ),
        ],
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
                    builder: (context) => const HomeBottomSheetWidget(),
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
    );
  }
}
