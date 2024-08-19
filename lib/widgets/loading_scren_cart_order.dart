import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreenCart extends StatelessWidget {
  const LoadingScreenCart({super.key});

  @override
  Widget build(BuildContext context) {
    print("LoadingScreenCart is being built");
    return Container(
      color: Colors.white,
      child: Center(
        child: Lottie.asset(
          'images/loading_cart_animation.json', // Path to your Lottie JSON file
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}