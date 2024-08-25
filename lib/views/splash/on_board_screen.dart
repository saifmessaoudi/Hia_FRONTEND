import 'package:flutter/material.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/views/authentication/sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  PageController pageController = PageController(initialPage: 0);

  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/onboard1.png',
      "title": 'Welcome to Hia',
      "description": 'Discover your favorite food at nearby places.',
    },
    {
      "icon": 'images/onboard2.png',
      "title": 'Find Your Favorite Food',
      "description": 'Book easily and get a confirmation ID instantly.',
    },
    {
      "icon": 'images/onboard3.png',
      "title": 'Enjoy you Experience!',
      "description": 'Navigate to your reservation and enjoy!',
    },
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          children: [
            Consumer<OnBoardingProvider>(
              builder: (context, provider, child) {
                return provider.currentIndexPage < sliderList.length - 1
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()),
                                (route) => false,
                              );
                            },
                            child: Text(
                              'Skip',
                              style: AppStyles.interMediumHeadline6
                                  .medium()
                                  .copyWith(
                                      color: kSecondaryColor, fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(height: 55);
              },
            ),
            Expanded(
              child: PageView.builder(
                itemCount: sliderList.length,
                controller: pageController,
                onPageChanged: (int index) {
                  context
                      .read<OnBoardingProvider>()
                      .setCurrentIndexPage(index);
                },
                itemBuilder: (_, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        sliderList[index]['icon'],
                        fit: BoxFit.contain,
                        width: context.width() * 0.8,
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          sliderList[index]['title'].toString(),
                          textAlign: TextAlign.center,
                          style: AppStyles.interMediumHeadline6
                              .bold()
                              .withColor(Colors.black)
                              .withSize(30),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          sliderList[index]['description'].toString(),
                          textAlign: TextAlign.center,
                          style: AppStyles.interregularTitle.copyWith(
                              color: Colors.blueGrey, fontSize: 18),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Consumer<OnBoardingProvider>(
              builder: (context, provider, child) {
                return DotIndicator(
                  currentDotSize: 15,
                  dotSize: 6,
                  pageController: pageController,
                  pages: sliderList,
                  indicatorColor: kMainColor,
                  unselectedIndicatorColor: kSecondaryColor,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: GestureDetector(
                onTap: () {
                  final provider =
                      context.read<OnBoardingProvider>();
                  if (provider.currentIndexPage < sliderList.length - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignIn()),
                      (route) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35.0),
                    color: kMainColor,
                  ),
                  child: Center(
                    child: Consumer<OnBoardingProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          provider.currentIndexPage < sliderList.length - 1
                              ? 'Next'
                              : 'Get Started',
                          style: kTextStyle.copyWith(
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class OnBoardingProvider with ChangeNotifier {
  int _currentIndexPage = 0;

  int get currentIndexPage => _currentIndexPage;

  void setCurrentIndexPage(int index) {
    _currentIndexPage = index;
    notifyListeners();
  }
}