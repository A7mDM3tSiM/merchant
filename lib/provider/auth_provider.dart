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
        msg: "Enter the username first",
        backgroundColor: Colors.red,
      );
      return false;
    }
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Enter the password first",
        backgroundColor: Colors.red,
      );
      return false;
    }
    return true;
  }

  Future<void> login() async {
    startLoading();
    final user = await _repo.verfyUser(
      usernameController.text,
      passwordController.text,
    );

    if (user != null) {
      prefs.setString("user_id", user.id);
      prefs.setString("user_store_name", user.storename);
      Fluttertoast.showToast(
        msg: "Logged in succesfully",
        backgroundColor: Colors.green,
      );
    }

    stopLoading();
  }

  Future<void> logout() async {
    prefs.clear();

    notifyListeners();
  }
}
