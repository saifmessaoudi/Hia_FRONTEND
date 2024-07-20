import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/utils/loading_widget.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/foodPreference/food_preferences_screen.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/constant.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({super.key});

  @override
  _LocationPermissionState createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {
  final UserService userService = UserService();
  bool isLoading = false;

  String? userId;
  Position? position;

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveUserLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.initSession();

      position = await userViewModel.determinePosition();
      String? addresse = await userViewModel.getAddressFromCoordinates(
          position!.latitude, position!.longitude);

      userService.updateUserLocation(userViewModel.userId!, addresse!,
          position!.longitude, position!.latitude);
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FoodPreferencePage()),
      );

      const CustomToastWidget( isError: false, message: 'Location updated successfully',);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update location: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/hiaauthbgg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: kTitleColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    width: context.width(),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        Image.asset('images/mapsmall.png'),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text(
                            'Find restaurants and your Favorite food',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nec enim pellentesque aliquam auctor fringilla risus. ',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: kGreyTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        isLoading
                            ? const LoadingWidget(
                                color: kMainColor,
                                spacing: 10.0,
                              )
                            : ButtonGlobal(
                                buttonTextColor: Colors.white,
                                buttontext: 'Allow Location Access',
                                buttonDecoration: kButtonDecoration.copyWith(
                                    color: kMainColor),
                                onPressed: () {
                                  saveUserLocation();
                                },
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Enter My Location',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: kGreyTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
