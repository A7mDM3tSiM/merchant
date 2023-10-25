import 'package:flutter/material.dart';
import 'package:merchant/provider/auth_provider.dart';
import 'package:merchant/view/home/home_view.dart';
import 'package:merchant/view/spalsh/splash_view.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        if (auth.isLoggedIn) {
          return const HomeView();
        }
        return const SplashView();
      },
    );
  }
}
