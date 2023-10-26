import 'package:flutter/material.dart';
import 'package:merchant/provider/auth_provider.dart';
import 'package:merchant/view/widgets/global_confirm_button.dart';
import 'package:provider/provider.dart';

class LoginConatinerWidget extends StatelessWidget {
  const LoginConatinerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Container(
      width: w * 0.85,
      padding: EdgeInsets.symmetric(vertical: h * 0.05),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(h * 0.01),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "تسجيل دخول",
            style: TextStyle(
              fontSize: h * 0.06,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: h * 0.05,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(h * 0.01),
                  child: Consumer<AuthProvider>(
                    builder: (_, login, __) => Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: login.usernameController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: h * 0.02,
                        ),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: w * 0.025),
                          hintText: "اسم المستخدم",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(h * 0.01),
                  child: Consumer<AuthProvider>(
                    builder: (_, login, __) => Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TextField(
                        controller: login.passwordController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: h * 0.02,
                        ),
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: w * 0.025),
                          hintText: "كلمة المرور",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: h * 0.075,
          ),
          Consumer<AuthProvider>(
            builder: (_, auth, __) {
              if (auth.isLoading) {
                return const CircularProgressIndicator.adaptive();
              }
              return ConfirmButton(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (auth.validate()) {
                    auth.login();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
