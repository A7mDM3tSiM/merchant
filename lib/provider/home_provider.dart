import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeProvider extends ChangeNotifier {
  DateTime willPop = DateTime.now();

  final nameController = TextEditingController();
  final countController = TextEditingController();
  final priceController = TextEditingController();
  final searchController = TextEditingController();

  PersistentBottomSheetController? controller;
  bool isBottomSheetOpened = false;

  Future<bool> onWillpop() async {
    var onPress = DateTime.now();
    var diffrance = onPress.difference(willPop).inSeconds;

    if (diffrance > 2) {
      willPop = DateTime.now();
      Fluttertoast.showToast(
        msg: "اضغط مرة اخري للخروج من التطبيق",
        backgroundColor: Colors.grey,
        fontSize: 20,
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  bool isAllFieldsFilled() {
    if (nameController.text.isEmpty ||
        countController.text.isEmpty ||
        priceController.text.isEmpty) {
      // Notify of unfilled fields
      Fluttertoast.showToast(
        msg: "قم بملء جميع الحقول",
        backgroundColor: Colors.red,
        fontSize: 20,
      );
      return false;
    }
    return true;
  }

  void clearAndReset() {
    nameController.clear();
    countController.clear();
    priceController.clear();
  }

  /// This function is used to toggle the floating action button icon
  /// and close the bottom sheet
  Future<void> closeBottomSheet() async {
    isBottomSheetOpened = false;
    if (controller != null) {
      controller?.close();
      controller = null;
    }
    clearAndReset();
    notifyListeners();
  }

  /// This function is used to toggle the floating action button icon
  /// and has nothing to do with opening the bottomsheet
  void openBottomSheet() {
    isBottomSheetOpened = true;
    notifyListeners();
  }
}
