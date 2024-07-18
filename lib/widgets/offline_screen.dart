import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:hia/constant.dart';
import 'package:hia/utils/connectivity_manager.dart';
import 'package:hia/widgets/styled_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:hia/helpers/debugging_printer.dart'; // Ensure to import your debugging printer if necessary

class DisconnectedWidget extends StatefulWidget {
  const DisconnectedWidget({Key? key}) : super(key: key);

  @override
  _DisconnectedWidgetState createState() => _DisconnectedWidgetState();
}

class _DisconnectedWidgetState extends State<DisconnectedWidget> {
  late ConnectivityManager _connectivityManager; // Instance of ConnectivityManager

  @override
  void initState() {
    super.initState();
    _connectivityManager = Provider.of<ConnectivityManager>(context, listen: false); // Obtain instance of ConnectivityManager
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = _connectivityManager.isConnected; // Get current connectivity status

    return Scaffold(
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/offline_icon.png",
            width: 110.w,
            height: 110.h,
          ),
          Gap(35.h),
          Text(
            isConnected ? 'Connected to the internet.' : 'No internet connection.',
            textAlign: TextAlign.center,
            style: AppStyles.interregularTitle.withColor(AppColors.lightGrey).withSize(FontSizes.headline6),
          ),
          Gap(30.h),
          StyledButton(
            style: ButtonStyles.primary,
            title: 'Try again',
            onPressed: (){
              isConnected ? debugPrint("Connected !!!") : debugPrint('No internet connection');
            },
            reversed: true,
            icon: Image.asset(
              "images/refresh_icon.png",
              width: 17.w,
              height: 19.h,
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 40).center(),
    );
  }
}
