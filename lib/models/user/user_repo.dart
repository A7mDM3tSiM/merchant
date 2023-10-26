import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merchant/models/user/user_model.dart';
import 'package:merchant/services/firebase_service.dart';

class UserRepo {
  final fb = FirebaseService(collectionPath: "users");

  Future<User?> verfyUser(String username, String password) async {
    try {
      // get all users from database
      final users = await fb.getCollectionDocs();

      // get the user which the cutomer entered it's username
      // throw an error if the user does not exist
      final thisUser = users.where((usr) => usr?['username'] == username).first;

      // verfy that the entered password is correct
      if (thisUser?['password'] == password) {
        return User.fromMap(thisUser);
      } else {
        Fluttertoast.showToast(
          msg: "كلمة المرور غير صحيحة",
          backgroundColor: Colors.red,
        );
        return null;
      }
    } on StateError {
      Fluttertoast.showToast(
        msg: "اسم المستخدم غير صحيح",
        backgroundColor: Colors.red,
      );
      return null;
    }
  }
}
