import '../../view/home/home_view.dart';
import '../../view/product/product_view.dart';
import '../../view/spalsh/splash_view.dart';

class Routes {
  // assign routes to static strings to avoid string confusion
  static String splashRoute = '/';
  static String homeRoute = '/home';
  static String productRoute = '/product';

  /// a set contain all the app routes assigned to widgets
  // (_) is context but it's not needed
  static final routes = {
    splashRoute: (_) => const SplashView(),
    homeRoute: (_) => const HomeView(),
    productRoute: (_) => const ProductView(),
  };
}
