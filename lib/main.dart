import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merchant/provider/auth_provider.dart';
import 'package:merchant/provider/home_provider.dart';
import 'package:merchant/provider/products_provider.dart';
import 'package:merchant/provider/report_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/routes/routes.dart';
import 'components/theme/theme.dart';
import 'components/theme/theme_manger.dart';
import 'services/navigation_service.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
late SharedPreferences prefs;

Future<void> main() async {
  // Global Init
  WidgetsFlutterBinding.ensureInitialized();

  // Easylocalization
  await EasyLocalization.ensureInitialized();

  // Init navigation services
  await NavigationService.init();

  // Init Firebase
  await Firebase.initializeApp();

  // Init SharedPreferences
  prefs = await SharedPreferences.getInstance();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeManegerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportProvider(),
        ),
      ],
      child: Consumer<ThemeManegerProvider>(
        builder: (_, theme, __) {
          return MaterialApp(
            routes: Routes.routes,
            initialRoute: Routes.wrapperRpute,
            scaffoldMessengerKey: scaffoldMessengerKey,
            navigatorKey: NavigationService.navKey,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: theme.themeMode,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: const Locale('en'),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
