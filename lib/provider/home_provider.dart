import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final countController = TextEditingController();
  final priceController = TextEditingController();

  PersistentBottomSheetController? controller;
  bool isBottomSheetOpened = false;

  bool isAllFieldsFilled() {
    if (nameController.text.isEmpty ||
        countController.text.isEmpty ||
        priceController.text.isEmpty) {
      return false;
    }
    return true;
  }

  /// This function is used to toggle the floating action button icon
  /// and close the bottom sheet
  void closeBottomSheet() {
    isBottomSheetOpened = false;
    if (controller != null) {
      controller?.close();
      controller = null;
    }
    notifyListeners();
  }

  /// This function is used to toggle the floating action button icon
  /// and has nothing to do with opening the bottomsheet
  void openBottomSheet() {
    isBottomSheetOpened = true;
    notifyListeners();
  }
}
