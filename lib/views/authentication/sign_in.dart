import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hia/constant.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/utils/loading_widget.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/authentication/forget_password_screen.dart';
import 'package:hia/views/authentication/phone_auth.dart';
import 'package:hia/views/authentication/registration/sign_up.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/views/location/location_permission.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = UserService();

  String? emailError;
  String? passwordError;
  bool isLoading = false;

  void showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.done,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(kMainColor),
            ),
          ),
        ],
      ),
    );
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30.0),
               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[ 
                    SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image.asset(
                      'images/h_logo_white.png',
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                 
                  ]
                ),
              const Gap(13),
                  const Text(
                    'Welcome to Hia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 25.0),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width ,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Colors.white,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Lottie.asset(
                                'images/lottie.json', // Replace with your Lottie animation file path
                                height: 200, // Adjust height as needed
                                width: double.infinity, // Take full width
                                fit: BoxFit.contain, // Adjust fit as needed
                              ),
                   const SizedBox(height: 8.0),
                                _buildEmailField(),
                                const SizedBox(height: 20.0),
                                _buildPasswordField(),
                                const SizedBox(height: 10.0),
                                _buildForgotPasswordRow(context),
                                const SizedBox(height: 10.0),
                                _buildLoginButton(context),
                                const SizedBox(height: 10.0),
                                _buildSignUpRow(context),
                                const SizedBox(height: 10.0),
                                _buildOrDivider(),
                                const SizedBox(height: 10.0),
                                _buildFacebookButton(),
                                const SizedBox(height: 10.0),
                                _buildTermsAndPrivacyText(),
                              ],
                            ),
                          ),
                        );
                      },
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

  Widget _buildEmailField() {
    return AppTextField(
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
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 187, 187, 187),
        ),
        floatingLabelStyle: const TextStyle(
          color: kMainColor,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
      controller: passwordController,
      cursorColor: kMainColor,
      textFieldType: TextFieldType.PASSWORD,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Password',
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
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 187, 187, 187),
        ),
        floatingLabelStyle: const TextStyle(
          color: kMainColor,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Forgot your password?  ',
            style: TextStyle(
              fontSize: 15.0,
              color: kTitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgetPassword()),
              );
            },
            child: const Text(
              'Here',
              style: TextStyle(
                fontSize: 15.0,
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ButtonGlobal(
      buttonTextColor: Colors.white,
      buttontext: 'Log In',
      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
      onPressed: () async {
        setState(() {
          emailError = emailController.text.isEmpty
              ? 'Please enter your email'
              : !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(emailController.text)
                  ? 'Please enter a valid email'
                  : null;
          passwordError = passwordController.text.isEmpty
              ? 'Please enter your password'
              : passwordController.text.length < 6
                  ? 'Password must be at least 6 characters long'
                  : null;
        });

        if (emailError == null && passwordError == null) {
          final authViewModel =
              Provider.of<UserViewModel>(context, listen: false);
          bool success = await authViewModel.login(
            emailController.text,
            passwordController.text,
          );

          if (success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LocationPermission()),
            );
          } else {
            setState(() {
              emailError = 'Invalid email or password';
              passwordError = 'Invalid email or password';
            });
          }
        }
      },
    );
  }

  Widget _buildSignUpRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Or create your account here   ',
            style: TextStyle(
              fontSize: 15.0,
              color: kTitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUp()),
              );
            },
            child: const Text(
              'SignUp',
              style: TextStyle(
                fontSize: 15.0,
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            thickness: 1.0,
            color: kGreyTextColor.withOpacity(0.3),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'or',
            style: kTextStyle.copyWith(color: kGreyTextColor),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            thickness: 1.0,
            color: kGreyTextColor.withOpacity(0.3),
          ),
        )),
      ],
    );
  }

  Widget _buildFacebookButton() {
    return GestureDetector(
      onTap: () {
        signInWithFacebook();
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, bottom: 10.0, top: 15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromARGB(255, 14, 85, 177),
          ),
          child: isLoading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingWidget(
                      color: white,
                      size: 10.0,
                      spacing: 10.0,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.facebookF,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Continue With Facebook',
                      style: kTextStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacyText() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'By continuing, you agree to our  ',
          style: kTextStyle.copyWith(color: kTitleColor),
          children: <TextSpan>[
            TextSpan(
                text: 'Terms & conditions',
                style: kTextStyle.copyWith(
                    fontWeight: FontWeight.bold, color: kSecondaryColor)),
            TextSpan(
              text: '  and ',
              style: kTextStyle.copyWith(color: kTitleColor),
            ),
            TextSpan(
                text: 'Privacy Policy',
                style: kTextStyle.copyWith(
                    fontWeight: FontWeight.bold, color: kSecondaryColor)),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithFacebook() async {
    String _token;
    String email = '';
    final authViewModel = Provider.of<UserViewModel>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final userData = await FacebookAuth.instance.getUserData();
        final accesToken = accessToken.tokenString;
        print('Access Token: $accesToken');

        final response = await http.post(
          Uri.parse('http://10.0.2.2:3030/user/facebook-login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'accessToken': accesToken,
          }),
        );

        final Map<String, dynamic>? responseData = jsonDecode(response.body);

        if (responseData != null && responseData.containsKey('token')) {
          _token = responseData['token'];
          email = responseData['user']["email"];

          await authViewModel.loginWithFacebook(_token);
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LocationPermission(),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PhoneAuth(email: email),
            ),
          );
        }
      } else {
        print('Message: ${result.message}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error during Facebook login: $e');
    }
  }
}
