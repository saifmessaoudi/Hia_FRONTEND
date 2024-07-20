// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/utils/loading_widget.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/foodPreference/food_preferences_screen.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/widgets/back_row.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../constant.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
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
  // List of user preferences
  List<String> userPreferences = [];

  Position? position;
  bool isLoading = false;
  bool isLoadingPosition = false;

  @override
  void initState() {
    super.initState();
    // Fetch the user data from the provider
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    // Initialize controllers with initial values
    firstNameController =
        TextEditingController(text: userViewModel.userData?.firstName ?? '');
    lastNameController =
        TextEditingController(text: userViewModel.userData?.lastName ?? '');
    emailController =
        TextEditingController(text: userViewModel.userData?.email ?? '');
    phoneController =
        TextEditingController(text: userViewModel.userData?.phone ?? '');

    // Initialize the user preferences
    userPreferences = userViewModel.userData?.foodPreference ?? [];  

  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> saveUserLocation() async {
    setState(() {
      isLoadingPosition = true;
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
        isLoadingPosition = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );

      showCustomToast(context, 'Location updated successfully');
    } catch (e) {
      setState(() {
        isLoadingPosition = false;
      });
      showCustomToast(context, 'Failed to update location', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Card(
          elevation: 0.0,
          color: kSecondaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      UserService userService = UserService();
                      final userViewModel =
                          Provider.of<UserViewModel>(context, listen: false);
                      userViewModel.initSession();
                      setState(() {
                        isLoading = true;
                      });
                      bool success = await userService.updateUserProfile(
                        userViewModel.userId!,
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                      if (success) {
                        showCustomToast(
                            context, 'Profile updated successfully');
                        setState(() {
                          isLoading = false;
                        });
                        userViewModel.fetchUserById(userViewModel.userId!);
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0)
                      ,
                      child: Container(
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: kMainColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoading
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
              children: [
                const Row(
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(20.0),
                      child:  BackRow(title: ""),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
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
                          height: 20.0,
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 90.0,
                              height: 90.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: ClipOval(
                                child: SizedBox(
                                  width: 10.0, // Set the width of the logo
                                  height: 10.0, // Set the height of the logo
                                  child: Image.asset(
                                    'images/h_logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: Image.asset('images/editpicicon.png'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 25.0),
                          child: AppTextField(
                            controller: firstNameController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: InputDecoration(
                              labelText: 'FirstName',
                              hintText: 'FirstName',
                              errorText: firstNameError,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Adjust the radius as needed
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Ensure the radius matches
                                borderSide: BorderSide(
                                  color:
                                      kSecondaryColor, // Change this to your desired color
                                  width: 2.0,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 187, 187, 187),
                              ),
                              floatingLabelStyle: const TextStyle(
                                color:
                                    kMainColor, // Color when the TextField is focused
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: AppTextField(
                            controller: lastNameController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: InputDecoration(
                              labelText: 'LastName',
                              hintText: 'LastName',
                              errorText: lastNameError,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Adjust the radius as needed
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Ensure the radius matches
                                borderSide: BorderSide(
                                  color:
                                      kSecondaryColor, // Change this to your desired color
                                  width: 2.0,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 187, 187,
                                    187), // Color when the TextField is unfocused
                              ),
                              floatingLabelStyle: const TextStyle(
                                color:
                                    kMainColor, // Color when the TextField is focused
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: AppTextField(
                            controller: emailController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.EMAIL,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Email',
                              errorText: emailError,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(
                                  color: kSecondaryColor,
                                  width: 2.0,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 187, 187,
                                    187), // Color when the TextField is unfocused
                              ),
                              floatingLabelStyle: const TextStyle(
                                color:
                                    kMainColor, // Color when the TextField is focused
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: AppTextField(
                            enabled: false,
                            controller: phoneController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.PHONE,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              errorText: passwordError,
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Adjust the radius as needed
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(
                                  color: kSecondaryColor,
                                  width: 2.0,
                                ),
                              ),
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 187, 187, 187),
                              ),
                              floatingLabelStyle: const TextStyle(
                                color: kTitleColor,
                              ),
                            ),
                          ),
                        ),

                        const Gap(10.0),
                       Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE: My Preferences
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'My Preferences',
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        const Gap(5.0),
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
                      spacing: 10.0,
                      runSpacing: 4.0,
                      children: userPreferences
                          .map(
                            (pref) => Chip(
                              backgroundColor: kMainColor,
                              label: Text(
                                pref,
                                style: kTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
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
                // Handle adding new preference
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
    )
                          ,
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 60.0),
                          child: GestureDetector(
                            onTap: () {
                              saveUserLocation();
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
          ],
        ),
      ),
    );
  }
}
