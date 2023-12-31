import 'package:flutter/material.dart';
import 'package:merchant/components/routes/routes.dart';
import 'package:merchant/main.dart';
import 'package:merchant/provider/auth_provider.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/provider/report_provider.dart';
import 'package:merchant/services/navigation_service.dart';
import 'package:merchant/view/widgets/product_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/home_bottom_sheet_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pro = context.read<ProductsProvider>();

      await pro.fecthProducts();
      pro.setNewMonthReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => context.read<HomeProvider>().onWillpop(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                prefs.getString("user_store_name") ?? "",
                style: TextStyle(color: Colors.black, fontSize: h * 0.023),
              ),
              leading: GestureDetector(
                onTap: () {
                  NavigationService.push(Routes.reportRoute);
                },
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.black,
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    context.read<AuthProvider>().logout();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 0.0,
            ),
            body: Stack(
              children: [
                ListView(
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
                          Container(
                            width: w * 0.9,
                            padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Consumer<HomeProvider>(
                                    builder: (_, home, __) => TextField(
                                      controller: home.searchController,
                                      onChanged: (value) {
                                        final pro =
                                            context.read<ProductsProvider>();
                                        pro.stopLoading();
                                      },
                                      textDirection: TextDirection.rtl,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: w * 0.03),
                                const Icon(
                                  Icons.search,
                                  color: Colors.black,
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
                        final home = context.read<HomeProvider>();
                        final listToShow =
                            pro.listToShow(home.searchController.text);
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
                        if (listToShow.isEmpty) {
                          return Column(
                            children: [
                              SizedBox(height: h * 0.3),
                              Center(
                                child: Text(
                                  "لا توجد منتجات",
                                  style: TextStyle(
                                    fontSize: h * 0.023,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return SizedBox(
                          height: h * 0.75,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listToShow.length,
                            itemBuilder: (context, index) => ProductWidget(
                              product: listToShow[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
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
          Consumer<ProductsProvider>(
            builder: (_, pro, __) {
              if (pro.isSettingNewReport) {
                return Scaffold(
                  body: Container(
                    height: h,
                    width: w,
                    color: Colors.grey[300],
                    child: Center(
                      child: Container(
                        height: h * 0.3,
                        width: w * 0.8,
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "!بداية شهر موفقة ان شاء الله",
                              style: TextStyle(fontSize: h * 0.023),
                            ),
                            Text(
                              "الرجاء الإنتظار ريثما يتم تهيئة نظام التقارير للشهر الجديد",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: h * 0.02),
                            ),
                            SizedBox(height: h * 0.05),
                            const CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
