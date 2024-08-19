import 'package:device_preview/device_preview.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hia/models/cart/cart.model.dart';
import 'package:hia/models/cart/cart_item.model.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/models/user.model.dart';
import 'package:hia/utils/connectivity_manager.dart';
import 'package:hia/utils/navigation_service.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/viewmodels/food_viewmodel.dart';
import 'package:hia/viewmodels/home/navigation_provider.dart';
import 'package:hia/viewmodels/offer.viewmodel.dart';
import 'package:hia/viewmodels/reservation_viewmodel.dart';
import 'package:hia/viewmodels/review.viewmodel.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/foodPreference/food_pref_provider.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/views/splash/on_board_screen.dart';
import 'package:hia/views/splash/splash_screen.dart';
import 'package:hia/views/splash/splash_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  await FastCachedImageConfig.init();
  
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(OfferAdapter());
  Hive.registerAdapter(EstablishmentAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(ReviewAdapter());
  Hive.registerAdapter(UserAdapter());

  await Hive.openBox<Food>('foodBox');
  await Hive.openBox<Establishment>('establishmentsBox');
  await Hive.openBox('offerBox');
  await Hive.openBox<Cart>('cartBox');
  await Hive.openBox<CartItem>('cartItemBox');
  
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }

  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ConnectivityManager(),
          child: const Home(),
        ),

        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(
          create: (context) => SplashViewModel(Provider.of<UserViewModel>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => FoodPreferenceProvider(
              Provider.of<UserViewModel>(context, listen: false)),
        ),
        ChangeNotifierProvider(create: (context) => EstablishmentViewModel( Provider.of<UserViewModel>(context, listen: false), Provider.of<FoodPreferenceProvider>(context, listen: false))),
        ChangeNotifierProvider(create: (context) => FoodViewModel(Provider.of<UserViewModel>(context, listen: false))),
        ChangeNotifierProvider(create: (context) => OfferViewModel()),
        ChangeNotifierProxyProvider<UserViewModel, FoodPreferenceProvider>(
          create: (context) => FoodPreferenceProvider(context.read<UserViewModel>()),
          update: (context, userViewModel, foodPreferenceProvider) => foodPreferenceProvider!..updateUserViewModel(userViewModel),
        ),
        ChangeNotifierProxyProvider<FoodPreferenceProvider, EstablishmentViewModel>(
          create: (context) => EstablishmentViewModel(Provider.of<UserViewModel>(context, listen: false), Provider.of<FoodPreferenceProvider>(context, listen: false)),
          update: (context, foodPreferenceProvider, establishmentViewModel) {
            establishmentViewModel!.listenToPreferences(foodPreferenceProvider);
            return establishmentViewModel;
          },
        ),
        ChangeNotifierProvider(create: (context) => CartViewModel()),
                ChangeNotifierProvider(create: (context) => ReservationViewModel()),

        ChangeNotifierProvider(create:  (context) => ReviewViewModel("")),
        ChangeNotifierProvider(
          create: (_) => NavigationModel(),)

      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          // ignore: deprecated_member_use
          useInheritedMediaQuery: true,
          builder: DevicePreview.appBuilder,
          locale: DevicePreview.locale(context),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
          ),
          title: 'Hia Tunisia',
          initialRoute: '/',
          navigatorKey: NavigationService.navigatorKey,
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboard': (context) => const OnBoard(),
            '/home': (context) => const Home(),
          },
        );
      },
    );
  }
}
