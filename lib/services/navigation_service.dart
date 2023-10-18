import 'package:flutter/material.dart';

class NavigationService {
  /// this key used to navigate from any screen without the need of context
  /// and get the context any where in the app
  static late final GlobalKey<NavigatorState> navKey;

  static Future<void> init() async {
    navKey = GlobalKey<NavigatorState>();
  }

  /// put a screen {route} on top of the current screen
  static void push(String route, {Object? arg}) {
    navKey.currentState?.pushNamed(route, arguments: arg);
  }

  /// replace the current screen with anthor screen {route}
  static void pushReplacement(String route, {Object? arg}) {
    navKey.currentState?.pushReplacementNamed(route, arguments: arg);
  }

  /// pop the current screen off the widget tree
  static void pop({Object? arguments}) {
    navKey.currentState?.pop(arguments);
  }

  /// pop the screen until [untilRoute]
  static void popUntil(String untilRoute) {
    // pop the screens till a certain route
    navKey.currentState?.popUntil(ModalRoute.withName(untilRoute));
  }

  /// pop all the screens and push [route]
  static void popAllAndPush(String route, {Object? arg}) {
    // pop all the screens
    navKey.currentState?.popUntil((route) => false);

    // push the new screen [route] with argumnets [arg]
    navKey.currentState?.pushNamed(route, arguments: arg);
  }

  /// pop all the screens until [untilRoute] and push [newRoute]
  static void popAndPush(String newRoute, String untilRoute, {Object? arg}) {
    // pop the screens till untillRoute
    navKey.currentState?.popUntil(ModalRoute.withName(untilRoute));

    // push the new screen [route] with argumnets [arg]
    navKey.currentState?.pushNamed(newRoute, arguments: arg);
  }
}
