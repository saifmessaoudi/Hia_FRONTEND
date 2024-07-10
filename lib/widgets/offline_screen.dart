

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
class DisconnectedWidget extends StatelessWidget {
  const DisconnectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/offline_icon.png",
              width: 100,
              height: 100,
            ),

           const Text(
              "Please connect to the internet and try again.",
              textAlign: TextAlign.center,
            ),
        
            
          ],
        ).paddingSymmetric(horizontal: 40).center());
  }
}
