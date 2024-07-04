import 'package:flutter/material.dart';
import 'package:hia/utils/navigation_service.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/foodPreference/food_pref_provider.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/views/splash/on_board_screen.dart';
import 'package:hia/views/splash/splash_screen.dart';
import 'package:hia/views/splash/splash_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(
              Provider.of<UserViewModel>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => FoodPreferenceProvider(
              Provider.of<UserViewModel>(context, listen: false)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      title: 'Hia Tunisia',
      initialRoute: '/',
      navigatorKey: NavigationService.navigatorKey,
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboard': (context) => const OnBoard(),
        '/home': (context) => const Home(),
      },
    );
  }
}