import 'package:flutter/material.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/authentication/phone_verification.dart';
import 'package:hia/views/authentication/sign_in.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/views/location/location_permission.dart';
import 'package:hia/views/profile/edit_profile.dart';
import 'package:hia/views/profile/profile_screen.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
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
        pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
      ),
      title: 'Maan LMS',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
      },
    );
  }
}
