// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hia/views/authentication/signin_screen.dart';

class SplashViewModel extends ChangeNotifier {

  final BuildContext context;

  SplashViewModel(this.context){
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignInScreen()),
    );
  }
}