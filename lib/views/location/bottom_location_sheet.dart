import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:hia/app/style/widget_modifier.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/utils/loading_widget.dart';
import 'package:hia/views/foodPreference/food_preferences_screen.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/views/location/map_picker_bottom_sheet.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:map_location_picker/map_location_picker.dart';

Future<void> showLocationOptions(BuildContext context) async {
  showModalBottomSheet(
    backgroundColor: kMainColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    context: context,
    builder: (context) {
      String selectedOption = 'manual'; // Initial selected option
      bool isLoadingPosition = false;
      Position? position;
      final UserService userService = UserService();

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          Future<void> saveUserLocation() async {
            setState(() {
              isLoadingPosition = true;
            });
            try {
              final userViewModel = Provider.of<UserViewModel>(context, listen: false);
              userViewModel.initSession();
              position = await userViewModel.determinePosition();
              String? address = await userViewModel.getAddressFromCoordinates(
                  position!.latitude, position!.longitude);
              await userService.updateUserLocation(
                  userViewModel.userId!, address!, position!.longitude, position!.latitude);
              setState(() {
                isLoadingPosition = false;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FoodPreferencePage()),
              );
              showCustomToast(context, 'Location updated successfully');
            } catch (e) {
              setState(() {
                isLoadingPosition = false;
              });
              showCustomToast(context, 'Failed to update location', isError: true);
            }
          }

          return SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose location option",
                  style: AppStyles.interSemiBoldTextButton
                      .withColor(Colors.white)
                      .withSize(FontSizes.headline5),
                ).align(alignment: Alignment.topLeft),
                Gap(26.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedOption = 'manual';
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.map, // Use an appropriate icon
                        color: selectedOption == 'manual'
                            ? Colors.white // Highlighted color
                            : Colors.white.withOpacity(0.5), // Non-highlighted color
                      ),
                      Gap(10.w),
                      Text(
                        "Manual Position",
                        style: AppStyles.interSemiBoldTextButton
                            .medium()
                            .withColor(selectedOption == 'manual'
                                ? Colors.white // Highlighted color
                                : Colors.white.withOpacity(0.5)) // Non-highlighted color
                            .withSize(FontSizes.title),
                      ),
                    ],
                  ),
                ),
                Gap(10.h),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedOption = 'current';
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.my_location, // Use an appropriate icon
                        color: selectedOption == 'current'
                            ? Colors.white // Highlighted color
                            : Colors.white.withOpacity(0.5), // Non-highlighted color
                      ),
                      Gap(10.w),
                      Text(
                        "Current Position",
                        style: AppStyles.interSemiBoldTextButton
                            .medium()
                            .withColor(selectedOption == 'current'
                                ? Colors.white // Highlighted color
                                : Colors.white.withOpacity(0.5)) // Non-highlighted color
                            .withSize(FontSizes.title),
                      ),
                    ],
                  ),
                ),
                Gap(20.h),
                isLoadingPosition
                    ? const LoadingWidget()
                    : ElevatedButton(
                        onPressed: () async {
                          if (selectedOption == 'current') {
                            await saveUserLocation();
                          } else if (selectedOption == 'manual') {
                            Navigator.pop(context);
                            showMapBottomSheet(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: kMainColor,
                        ),
                        child: Text('Validate'),
                      ),
              ],
            ),
          ).customPadding(
            right: 24.w,
            left: 24.w,
            top: 60.h,
            bottom: 14.h,
          );
        },
      );
    },
  );
}

void showMapBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return MapPickerBottomSheet(
        onLocationPicked: (latLng.LatLng position) {
          print('Picked position: ${position.latitude}, ${position.longitude}');
        },
        initialLocation: const latLng.LatLng(0.0, 0.0),
      );
    },
  );
}
