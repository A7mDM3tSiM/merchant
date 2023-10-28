import 'package:flutter/material.dart';

class SureWidget extends StatelessWidget {
  const SureWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      height: h,
      width: w,
      color: Colors.grey.withOpacity(0.5),
      child: Center(
        child: Container(
          height: h * 0.2,
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
              Icon(
                Icons.close_rounded,
                color: Colors.grey,
                size: h * 0.07,
              ),
              Text(
                "هل تريد حذف هذا المنتج فعلا؟",
                style: TextStyle(fontSize: h * 0.02),
              ),
              SizedBox(height: h * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: h * 0.02,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.05),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Colors.red,
                      ),
                    ),
                    child: Text(
                      'حذف',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: h * 0.02,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
