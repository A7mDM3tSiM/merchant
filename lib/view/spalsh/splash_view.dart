import 'package:flutter/material.dart';
import 'package:merchant/view/widgets/login_container.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoginConatinerWidget(),
      ),
    );
  }
}
