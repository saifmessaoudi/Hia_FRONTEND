import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/home/home.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../constant.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

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

  Position? position;

  @override
  void initState() {
    super.initState();
    // Fetch the user data from the provider
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    // Initialize controllers with initial values
    firstNameController =
        TextEditingController(text: userViewModel.userData?.firstName ?? '');
    print(firstNameController.text);
    lastNameController =
        TextEditingController(text: userViewModel.userData?.lastName ?? '');
    print(lastNameController.text);
    emailController =
        TextEditingController(text: userViewModel.userData?.email ?? '');
    print(emailController.text);
    phoneController =
        TextEditingController(text: userViewModel.userData?.phone ?? '');
    print(emailController.text);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.done,
              color: Colors.green, // Customize the color if needed
            ),
            SizedBox(width: 8), // Add some space between the icon and text
            Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  kMainColor), // Customize the text color
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveUserLocation() async {
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.initSession();

      position = await userViewModel.determinePosition();
      String? addresse = await userViewModel.getAddressFromCoordinates(
          position!.latitude, position!.longitude);

      userService.updateUserLocation(userViewModel.userId!, addresse!,
          position!.longitude, position!.latitude);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location updated successfully!'),
      ));
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

                      bool success = await userService.updateUserProfile(
                        userViewModel.userId!,
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                      if (success) {
                        showSuccessAlert('Profile updated successfully!');
                        userViewModel.fetchUserById(userViewModel.userId!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('check your data !'),
                        ));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: kMainColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ).onTap(() {
                        Navigator.pop(context);
                      }),
                    ),
                    Text(
                      'Edit Profile',
                      style: kTextStyle.copyWith(
                          color: Colors.white, fontSize: 18.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40.0,
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
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: ClipOval(
                                child: SizedBox(
                                  width: 10.0, // Set the width of the logo
                                  height: 10.0, // Set the height of the logo
                                  child: Image.asset(
                                    'images/portrait-man-laughing.png',
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Adjust the radius as needed
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Ensure the radius matches
                                borderSide: BorderSide(
                                  color:
                                      kSecondaryColor, // Change this to your desired color
                                  width: 2.0,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 187, 187,
                                    187), // Color when the TextField is unfocused
                              ),
                              floatingLabelStyle: TextStyle(
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Adjust the radius as needed
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    12.0)), // Ensure the radius matches
                                borderSide: BorderSide(
                                  color:
                                      kSecondaryColor, // Change this to your desired color
                                  width: 2.0,
                                ),
                              ),
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 187, 187,
                                    187), // Color when the TextField is unfocused
                              ),
                              floatingLabelStyle: TextStyle(
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
                              floatingLabelStyle: TextStyle(
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
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 80.0),
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
                                    Icon(Icons.location_on,
                                        color: kMainColor), // Location icon
                                    SizedBox(
                                        width:
                                            8.0), // Space between icon and text
                                    Text(
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
                        )
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
