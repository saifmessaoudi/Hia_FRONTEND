// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/utils/loading_widget.dart';
import 'package:hia/views/foodPreference/food_preferences_screen.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/views/location/bottom_location_sheet.dart';
import 'package:hia/views/profile/preference_chip.dart';
import 'package:hia/views/profile/profile_bottom_sheet.dart';
import 'package:hia/widgets/back_row.dart';
import 'package:hia/widgets/custom_toast.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final UserService userService = UserService();

  String? firstNameError;
  String? lastNameError;
  String? emailError;
  String? passwordError;
  List<String> userPreferences = [];
  Position? position;
  bool isLoading = false;
  bool isLoadingPosition = false;
  String selectedOption = '';

  @override
  void initState() {
    super.initState();
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    firstNameController.text = userViewModel.userData?.firstName ?? '';
    lastNameController.text = userViewModel.userData?.lastName ?? '';
    emailController.text = userViewModel.userData?.email ?? '';
    phoneController.text = userViewModel.userData?.phone ?? '';
    userPreferences = userViewModel.userData?.foodPreference ?? [];
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
  





  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        height: 80.0, // Adjusted height for the bottom navigation bar
        color: kSecondaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
                    bool success = await userService.updateUserProfile(
                      userViewModel.userId!,
                      firstNameController.text,
                      lastNameController.text,
                      emailController.text,
                      passwordController.text,
                    );
                    setState(() {
                      isLoading = false;
                    });
                    if (success) {
                      showCustomToast(context, 'Profile updated successfully');
                      userViewModel.fetchUserById(userViewModel.userId!);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    height: 55.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: kMainColor,
                    ),
                    child: Center(
                      child: isLoading
                          ? const LoadingWidget(
                              color: Colors.white,
                              size: 10.0,
                              spacing: 10.0,
                            )
                          : Text(
                              'Update Profile',
                              style: kTextStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/hiaauthbgg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: BackRow(title: ""),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 90.0, 
                                  height: 90.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: 'https://mir-s3-cdn-cf.behance.net/user/276/180d9c144450013.5cde903578dd7.jpg',
                                      placeholder: (context, url) => Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 80.0,
                                          width: 80.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  right: 0.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: kMainColor,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                                        context: context,
                                        builder: (context) => const ProfileBottomSheet(),
                                      );
                                    },
                                    child: Image.asset('images/editpicicon.png'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            AppTextField(
                              controller: firstNameController,
                              cursorColor: kMainColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(
                                labelText: 'FirstName',
                                hintText: 'FirstName',
                                errorText: firstNameError,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                    color: kSecondaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                labelStyle: const TextStyle(color: Color.fromARGB(255, 187, 187, 187)),
                                floatingLabelStyle: const TextStyle(color: kMainColor),
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            AppTextField(
                              controller: lastNameController,
                              cursorColor: kMainColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: InputDecoration(
                                labelText: 'LastName',
                                hintText: 'LastName',
                                errorText: lastNameError,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                    color: kSecondaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                labelStyle: const TextStyle(color: Color.fromARGB(255, 187, 187, 187)),
                                floatingLabelStyle: const TextStyle(color: kMainColor),
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            AppTextField(
                              controller: emailController,
                              cursorColor: kMainColor,
                              textFieldType: TextFieldType.EMAIL,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Email',
                                errorText: emailError,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                    color: kSecondaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                labelStyle: const TextStyle(color: Color.fromARGB(255, 187, 187, 187)),
                                floatingLabelStyle: const TextStyle(color: kMainColor),
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            AppTextField(
                              enabled: false,
                              controller: phoneController,
                              cursorColor: kMainColor,
                              textFieldType: TextFieldType.PHONE,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                errorText: passwordError,
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                    color: kSecondaryColor,
                                    width: 2.0,
                                  ),
                                ),
                                labelStyle: const TextStyle(color: Color.fromARGB(255, 187, 187, 187)),
                                floatingLabelStyle: const TextStyle(color: kTitleColor),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'My Preferences',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                 Gap(10.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Wrap(
                                              spacing: 12.0,
                                              runSpacing: 4.0,
                                              children: userPreferences
                                                  .map(
                                                    (pref) => PreferenceChipElement(
                                                        pref: pref,
                                                      ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const FoodPreferencePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 60.0),
                            child: GestureDetector(
                              onTap: () {
                                showLocationOptions(context);
                              },
                              child: Material(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.white,
                                elevation: 3.0, // Adds shadow to the container
                                child: Container(
                                  height: 55.0,
                                  width: 200.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: Border.all(
                                        color: kMainColor,
                                        width:
                                            2.0), // Border with kMainColor and width 2.0
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: kMainColor), // Location icon
                                      const SizedBox(
                                          width:
                                              8.0), // Space between icon and text
                                      isLoadingPosition
                                          ? const LoadingWidget(
                                              color: kMainColor,
                                              size: 10.0,
                                              spacing: 10.0,
                                            )
                                          : Text(
                                              'Update Position',
                                              style: kTextStyle.copyWith(
                                                color: kMainColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
          ),
        ),
      ),
    );
     }
}
