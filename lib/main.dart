import 'package:flutter/material.dart';
import 'package:merchant/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/routes/routes.dart';
import 'components/theme/theme.dart';
import 'components/theme/theme_manger.dart';
import 'services/navigation_service.dart';
import 'services/network_service.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
late SharedPreferences prefs;

Future<void> main() async {
  // Global Init
  WidgetsFlutterBinding.ensureInitialized();

  // Init navigation services
  await NavigationService.init();

  // Init Networkservices
  NetworkService.init();

  // Init SharedPreferences
  prefs = await SharedPreferences.getInstance();

  // Init database
  DatabaseService.init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManegerProvider>(
          create: (_) => ThemeManegerProvider(),
        ),
      ],
      child: Consumer<ThemeManegerProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            routes: Routes.routes,
            initialRoute: Routes.splashRoute,
            scaffoldMessengerKey: scaffoldMessengerKey,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: theme.themeMode,
            locale: const Locale('ar'),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
