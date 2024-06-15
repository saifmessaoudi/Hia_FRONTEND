import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/splash/splash_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize animation
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Simulate loading delay
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the next screen or perform another action here
      // For example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SplashViewModel>(context);

    return Scaffold(
      body: Center(
        child: Consumer<SplashViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('images/logo-color-8.png'),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 10.0,
                          height: 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _animation.value > (index * 0.3) ? kMainColor : gray,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
