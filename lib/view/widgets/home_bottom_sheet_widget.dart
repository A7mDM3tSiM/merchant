import 'package:flutter/material.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/view/widgets/global_confirm_button.dart';
import 'package:provider/provider.dart';

class HomeBottomSheetWidget extends StatelessWidget {
  const HomeBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        Row(
          children: [
            Consumer<HomeProvider>(
              builder: (_, home, __) => TextField(
                controller: home.nameController,
                keyboardType: TextInputType.name,
              ),
            ),
            const Text("Name"),
          ],
        ),
        Row(
          children: [
            Consumer<HomeProvider>(
              builder: (_, home, __) => TextField(
                controller: home.countController,
                keyboardType: const TextInputType.numberWithOptions(),
              ),
            ),
            const Text("Count"),
          ],
        ),
        Row(
          children: [
            Consumer<HomeProvider>(
              builder: (_, home, __) => TextField(
                controller: home.priceController,
                keyboardType: const TextInputType.numberWithOptions(),
              ),
            ),
            const Text("Price"),
          ],
        ),
        SizedBox(height: h * 0.03),
        ConfirmButton(
          onTap: () {
            final pro = context.read<ProductsProvider>();
            final home = context.read<HomeProvider>();

            if (home.isAllFieldsFilled()) {
              pro.addProduct(
                home.nameController.text,
                price: int.tryParse(home.priceController.text),
                totalBought: int.tryParse(home.countController.text),
              );
            }
          },
        ),
      ],
    );
  }
}
