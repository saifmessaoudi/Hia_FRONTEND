import 'package:flutter/material.dart';
import 'package:hia/views/Authentication/sign_up.dart';
import 'package:hia/views/authentication/sign_in.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
                          debugShowCheckedModeBanner: false,

      theme: ThemeData(
        // Add the line below to get horizontal sliding transitions for routes.
        pageTransitionsTheme: const PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
      ),
      title: 'Maan LMS',
      initialRoute: '/',
      routes: {
        '/': (context) => const SignUp(),
      },
    );
  }
}
