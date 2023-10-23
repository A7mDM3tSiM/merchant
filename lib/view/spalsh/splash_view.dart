import 'package:flutter/material.dart';
import 'package:merchant/components/routes/routes.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/services/navigation_service.dart';
import 'package:provider/provider.dart';

import '../../components/theme/theme_manger.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    final pro = context.read<ProductsProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        NavigationService.pushReplacement(Routes.homeRoute);
        await pro.fecthProducts();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: h * 0.1,
              width: w,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: w * 0.15,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Text(
                      "Demo",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: h * 0.05, color: Colors.white),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Consumer<ThemeManegerProvider>(
                      builder: (_, theme, __) => SizedBox(
                        height: h * 0.1,
                        child: FittedBox(
                          child: Switch(
                            value: theme.themeMode == ThemeMode.dark,
                            onChanged: (newValue) {
                              theme.themeMode =
                                  newValue ? ThemeMode.dark : ThemeMode.light;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "Title Text",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: h * 0.1),
            ),
            Text(
              "Sub Title Text",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: h * 0.05),
            ),
            Text(
              "Regular Text For Discription",
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontSize: h * 0.025),
            ),
            SizedBox(
              height: h * 0.1,
              width: w,
              child: TextFormField(
                style: TextStyle(fontSize: h * 0.03),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
