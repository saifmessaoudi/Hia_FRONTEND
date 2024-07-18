import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/utils/connectivity_manager.dart';
import 'package:hia/utils/navigation_service.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/viewmodels/food_viewmodel.dart';
import 'package:hia/viewmodels/offer.viewmodel.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/foodPreference/food_pref_provider.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/views/splash/on_board_screen.dart';
import 'package:hia/views/splash/splash_screen.dart';
import 'package:hia/views/splash/splash_view.dart';
import 'package:hia/widgets/offline_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(FoodAdapter());
  Hive.registerAdapter(OfferAdapter());
  Hive.registerAdapter(EstablishmentAdapter());

  Hive.openBox('foodBox');
  Hive.openBox('establishmentBox');
  Hive.openBox('offerBox');
  
  

  

  runApp(
    
    MultiProvider(
      providers: [
         ChangeNotifierProvider(
            create: (context) => ConnectivityManager(),),

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


      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
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
