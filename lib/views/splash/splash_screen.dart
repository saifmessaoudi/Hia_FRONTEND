import 'package:flutter/material.dart';
import 'package:hia/views/splash/splash_view.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SplashViewModel(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: const Scaffold(
        body: Center(
          child: Image(
            image: AssetImage('images/logo-color-8.png'),
          ),
        ),
      ),
    );
  }
}
