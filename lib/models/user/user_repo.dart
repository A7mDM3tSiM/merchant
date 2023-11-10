import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merchant/models/user/user_model.dart';
import 'package:merchant/services/firebase_service.dart';

class UserRepo {
  final fb = FirebaseService(collectionPath: "users");

  Future<User?> verfyUser(String username, String password) async {
    // get the user data by field
    final thisUser = await fb.getDocByfiled('username', username);

    // verfy that the entered password is correct
    if (thisUser != null) {
      if (thisUser['password'] == password) {
        return User.fromMap(thisUser);
      } else {
        Fluttertoast.showToast(
          msg: "كلمة المرور غير صحيحة",
          backgroundColor: Colors.red,
          fontSize: 20,
        );
        return null;
      }
    } else {
      Fluttertoast.showToast(
        msg: "اسم المستخدم غير صحيح",
        backgroundColor: Colors.red,
        fontSize: 20,
      );
      return null;
    }
  }
}
