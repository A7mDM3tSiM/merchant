import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onTap;
  const ConfirmButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: h * 0.06,
        width: w * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: h * 0.02),
          ),
        ),
      ),
    );
  }
}
