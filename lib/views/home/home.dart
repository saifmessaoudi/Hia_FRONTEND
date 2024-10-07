import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hia/constant.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/views/card/cart_screen.dart';
import 'package:hia/views/markets/market_screen.dart';
import 'package:hia/views/offers/fetch_offers.dart';
import 'package:hia/views/profile/profile_screen.dart';
import 'package:hia/widgets/smart_scaffold.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  final int initialIndex;
  const Home({super.key, this.initialIndex = 0});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );
  final ValueNotifier<int> _selectedItemPosition = ValueNotifier<int>(0);
  late PageController _pageController;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MarketsScreen() ,
    CartScreen(),
    OffersScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedItemPosition.value = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        return ValueListenableBuilder<int>(
          valueListenable: _selectedItemPosition,
          builder: (context, selectedIndex, child) {
            return SmartScaffold(
              body: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  _selectedItemPosition.value = index;
                },
                physics: const NeverScrollableScrollPhysics(),
                children: _widgetOptions, 
              ),
              bottomNavigationBar: Container(
                height: 78.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _borderRadius,
                ),
                child: SnakeNavigationBar.color(
                  backgroundColor: Colors.white,
                  behaviour: SnakeBarBehaviour.floating,
                  snakeShape: SnakeShape.rectangle.copyWith(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(borderRadius: _borderRadius),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  snakeViewColor: kMainColor,
                  unselectedItemColor: kMainColor,
                  currentIndex: selectedIndex,
                  onTap: (index) {
                    _selectedItemPosition.value = index;
                    _pageController.jumpToPage(index);
                  },
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Home',
                    ),
                      const BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.store),
                      label: 'Market',
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        children: [
                          const Icon(Icons.shopping_cart_outlined),
                          if (cartViewModel.cartLength > 0)
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: selectedIndex == 2 ? Colors.white : kMainColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${cartViewModel.cartLength}',
                                  style: TextStyle(
                                    color: selectedIndex == 2 ? kMainColor : Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      label: 'Cart',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.wallet_giftcard_rounded),
                      label: 'Offer',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline_rounded),
                      label: 'Profile',
                    ),
                  ],
                  selectedLabelStyle: const TextStyle(fontSize: 14),
                  unselectedLabelStyle: const TextStyle(fontSize: 10),
                ),
              ),
            );
          },
        );
      },
    );
  }
}