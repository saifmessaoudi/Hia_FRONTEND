import 'package:flutter/material.dart';
import 'package:hia/views/authentication/sign_in.dart';

class SplashViewModel extends ChangeNotifier {
  final BuildContext context;

  SplashViewModel(this.context) {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }
}
