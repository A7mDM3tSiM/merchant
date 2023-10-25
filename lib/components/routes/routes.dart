import 'package:merchant/wrapper.dart';

import '../../view/home/home_view.dart';
import '../../view/product/product_view.dart';
import '../../view/spalsh/splash_view.dart';

class Routes {
  // assign routes to static strings to avoid string confusion
  static String wrapperRpute = '/';
  static String splashRoute = '/splash';
  static String homeRoute = '/home';
  static String productRoute = '/product';

  /// a set contain all the app routes assigned to widgets
  // (_) is context but it's not needed
  static final routes = {
    wrapperRpute: (_) => const Wrapper(),
    splashRoute: (_) => const SplashView(),
    homeRoute: (_) => const HomeView(),
    productRoute: (_) => const ProductView(),
  };
}
