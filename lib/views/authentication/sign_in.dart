import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hia/constant.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/authentication/sign_up.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/views/location/location_permission.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = UserService();
  



  String? emailError;
  String? firstNameError;
  String? lastNameError;
  String? passwordError;


void showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
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
             // Navigator.push(
               // context,
              //  //MaterialPageRoute(builder: (context) => LoginPage()),
            //  );
             Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: Text('OK'),
             style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(kMainColor), // Customize the text color
          ),          ),
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
                  image: AssetImage("images/authbg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                  child: SizedBox(
                      width: context.width() / 2,
                      child: Text(
                        'Sign Up & Log In to Hia',
                        style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )),
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
                         Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 30.0),
                          child: AppTextField(
                            controller: emailController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.EMAIL,
                        decoration:  InputDecoration(
                         labelText: 'Email',
                          hintText: 'Email',
                            errorText: emailError,

  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)), // Adjust the radius as needed
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)), // Ensure the radius matches
    borderSide: BorderSide(
      color: kSecondaryColor, // Change this to your desired color
      width: 2.0,
    ),
  ),
  labelStyle: TextStyle(
    color: Color.fromARGB(255, 187, 187, 187), // Color when the TextField is unfocused
  ),
  floatingLabelStyle: TextStyle(
    color: kMainColor, // Color when the TextField is focused
  ),
),


                          ),
                        ),


                          Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 20.0,bottom: 20.0),
                          child: AppTextField(
                            controller: passwordController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.PASSWORD,
                        decoration:  InputDecoration(
                         labelText: 'Password',
                          hintText: 'Password',
                            errorText: passwordError,

  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)), // Adjust the radius as needed
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)), // Ensure the radius matches
    borderSide: BorderSide(
      color: kSecondaryColor, // Change this to your desired color
      width: 2.0,
    ),
  ),
  labelStyle: TextStyle(
    color: Color.fromARGB(255, 187, 187, 187), // Color when the TextField is unfocused
  ),
  floatingLabelStyle: TextStyle(
    color: kMainColor, // Color when the TextField is focused
  ),
),


                          ),
                        ),

                        
                         

                       
                       ButtonGlobal(
                          buttontext: 'Log In',
                          buttonDecoration:
                          kButtonDecoration.copyWith(color: kMainColor),
                         onPressed: () async {
            
                          
  setState(() {
emailError = emailController.text.isEmpty
    ? 'Please enter your email'
    : !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(emailController.text)
        ? 'Please enter a valid email'
        : null;
    firstNameError = firstNameController.text.isEmpty ? 'Please enter your FirsName' : null;
    lastNameError = lastNameController.text.isEmpty ? 'Please enter your lastName' : null;
passwordError = passwordController.text.isEmpty
    ? 'Please enter your password'
    : passwordController.text.length < 6
        ? 'Password must be at least 6 characters long'
        : null;


    // Add similar logic for other fields
  });

  if (emailError == null && passwordError == null) {
    //createUserAccount() ; 
    final authViewModel = Provider.of<UserViewModel>(context, listen: false);
                bool success = await authViewModel.login(
                  emailController.text,
                  passwordController.text,
                );

                if (success) {
                  
 Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => LocationPermission()),
);                  // Navigate to the next screen
                } else {
                   setState(() {
emailError = 'Invalid email or password';
    
passwordError = 'Invalid email or password';


    // Add similar logic for other fields
  });
  

                

                }

    
  }
},

                            //const PhoneVerification().launch(context);
                          
                        ),
                        
           const SizedBox(height: 10),
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Or create your account here   ',
        style: TextStyle(
          fontSize: 15.0,
          color: kTitleColor,
        ),
        textAlign: TextAlign.center,
      ),
      GestureDetector(
        onTap: () {
          // Navigate to Sign Up Page
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SignUp()),
);

        },
        child: Text(
          'SignUp',
          style: TextStyle(
            fontSize: 15.0,
            color: kMainColor, // You can change the color as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  ),
),

             
             
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(thickness: 1.0,color: kGreyTextColor.withOpacity(0.3),),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('or',style: kTextStyle.copyWith(color: kGreyTextColor),),
                            ),
                            Expanded(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(thickness: 1.0,color: kGreyTextColor.withOpacity(0.3),),
                            )),
                          ],
                        ),
                       Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0,bottom: 10.0,top: 15.0),
                          child: Container(
                            width: context.width(),
                            height: 60.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromARGB(255, 4, 57, 83),
                            ),
                            child: Row(
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
                                  style:
                                      kTextStyle.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'By continuing, you agree to our  ',

                              style: kTextStyle.copyWith(color: kTitleColor),
                              children: <TextSpan>[
                                TextSpan(text: 'Terms & conditions', style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kMainColor)),
                                TextSpan(text: '  and ', style: kTextStyle.copyWith(color: kTitleColor),),
                                TextSpan(text: 'Privacy Policy', style: kTextStyle.copyWith(fontWeight: FontWeight.bold,color: kMainColor)),
                              ],
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
