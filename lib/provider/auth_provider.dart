import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merchant/models/user/user_repo.dart';

import '../main.dart';

class AuthProvider extends ChangeNotifier {
  final _repo = UserRepo();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var _isLoading = false;

  bool get isLoggedIn {
    final userId = prefs.getString("user_id") ?? "";
    if (userId.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool get isLoading => _isLoading;

  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  bool validate() {
    if (usernameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "ادخل اسم المستخدم أولا",
        backgroundColor: Colors.red,
        fontSize: 20,
      );
      return false;
    }
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "اخل كلمة المرور أولا",
        backgroundColor: Colors.red,
        fontSize: 20,
      );
      return false;
    }
    return true;
  }

  Future<void> login() async {
    startLoading();
    final user = await _repo.verfyUser(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    if (user != null) {
      prefs.setString("user_id", user.id);
      prefs.setString("user_store_name", user.storename);
      Fluttertoast.showToast(
        msg: "تم تسجيل الدخول بنجاح",
        backgroundColor: Colors.green,
        fontSize: 20,
      );
    }

    stopLoading();
  }

  Future<void> logout() async {
    prefs.clear();

    notifyListeners();
  }
}
