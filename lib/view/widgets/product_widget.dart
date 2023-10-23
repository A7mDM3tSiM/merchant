import 'package:flutter/material.dart';
import 'package:merchant/models/product/product_model.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
      margin: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
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
          Text(product.name),
        ],
      ),
    );
  }
}
