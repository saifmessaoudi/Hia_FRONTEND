
import 'package:flutter/material.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/utils/navigation_service.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/views/home/home_screen.dart';
import 'package:hia/views/splash/on_board_screen.dart';
import 'package:hia/views/splash/splash_screen.dart';
import 'package:hia/views/splash/splash_view.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);

  // Register Hive adapter
  Hive.registerAdapter(EstablishmentAdapter());

  // Open Hive box
  await Hive.openBox<Establishment>('establishments');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => EstablishmentViewModel()),
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(Provider.of<UserViewModel>(context, listen: false)),
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
