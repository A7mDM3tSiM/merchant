import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merchant/components/routes/routes.dart';
import 'package:merchant/main.dart';
import 'package:merchant/models/user/user_model.dart';
import 'package:merchant/services/firebase_service.dart';
import 'package:merchant/services/navigation_service.dart';

class UserRepo {
  final fb = FirebaseService(collectionPath: "users");
  verfyUser(String username, String password) async {
    try {
      // get all users from database
      final users = await fb.getCollectionDocs();

      // get the user which the cutomer entered it's username
      // throw an error if the user does not exist
      final thisUser = users.where((usr) => usr?['username'] == username).first;

      // verfy that the entered password is correct
      if (thisUser?['password'] == password) {
        loginUser(User.fromMap(thisUser));
      } else {
        Fluttertoast.showToast(
          msg: "Wrong password",
          backgroundColor: Colors.red,
        );
      }
    } on StateError {
      Fluttertoast.showToast(
        msg: "Wrong username",
        backgroundColor: Colors.red,
      );
    }
  }

  void loginUser(User user) {
    prefs.setString("userId", user.id);
    NavigationService.pushReplacement(Routes.homeRoute);

    Fluttertoast.showToast(
      msg: "Logged in succesfully",
      backgroundColor: Colors.green,
    );
  }
}