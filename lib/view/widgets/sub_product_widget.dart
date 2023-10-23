import 'dart:math';

import 'package:flutter/material.dart';
import 'package:merchant/models/product/product_model.dart';

class SubProductWidget extends StatelessWidget {
  final SubProduct subProduct;
  const SubProductWidget({super.key, required this.subProduct});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.015),
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
                const Icon(
                  Icons.download,
                  color: Colors.amber,
                ),
                SizedBox(width: w * 0.03),
                Transform.rotate(
                  angle: pi,
                  child: const Icon(
                    Icons.download,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: w * 0.025),
                Text("${subProduct.currentCount} item"),
              ],
            ),
          ),
          SizedBox(width: w * 0.05),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${subProduct.price.toString()} pound"),
                Text(subProduct.name),
              ],
            ),
          ),
        ],
      ),
    );
  }
}