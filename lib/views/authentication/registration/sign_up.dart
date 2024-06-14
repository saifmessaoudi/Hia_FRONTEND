import 'package:flutter/material.dart';
//import 'package:maan_food/GlobalComponents/button_global.dart';
//import 'package:maan_food/Screens/Authentication/phone_verification.dart';
import 'package:hia/constant.dart';
import 'package:hia/services/user_service.dart';
import 'package:hia/utils/loading_widget.dart';
import 'package:hia/views/authentication/registration/registration_otp_phone.dart';
import 'package:hia/views/authentication/sign_in.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = UserService();
  bool isLoading = false;
  



  String? emailError;
  String? firstNameError;
  String? lastNameError;
  String? passwordError;


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

    Future<void> createUserAccount() async {
      setState(() {
        isLoading = true;
      });
    
      try {
        final response = await userService.signUp(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          passwordController.text,  
        );

        if (!response['success']) {
      setState(() {
        emailError = 'Email is already used' ; 
        isLoading = false;
       });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpPhoneOtp(email: emailController.text)),
      );
      setState(() {
        isLoading = false;
      });
     
    }
        // Navigator.pop(context); // Optional: Navigate to the next screen
      } catch (error) {
        print('Error: $error');
        //showErrorAlert("Error");
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
               
                Padding(
                  padding:
                  const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: SizedBox(
                      width: context.width(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Let’s get you started',
                            style: kTextStyle.copyWith(
                            color: kTitleColor,                                
                            fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'First, Create your Hia account',
                            style: kTextStyle.copyWith(
                              color: white,
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                
                Flexible(
                  
                  child: SingleChildScrollView(
                    
                  child: Container(
                    width: context.width(),
                    height: context.height()-200,
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
                       
                           Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: AppTextField(
                            controller: emailController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.EMAIL,
                        decoration:  InputDecoration(
                         labelText: 'Email',
                          hintText: 'Email',
                            errorText: emailError,

  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)), 
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)), 
    borderSide: BorderSide(
      color: kSecondaryColor, 
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
                          const SizedBox(
                          height: 12.0,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: AppTextField(
                            controller: firstNameController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.NAME,
                            decoration:  InputDecoration(
  labelText: 'FirstName',
  hintText: 'FirstName',
  errorText: firstNameError,
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
                        const SizedBox(
                          height: 12.0,
                        ),
                         Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: AppTextField(
                            controller: lastNameController,
                            cursorColor: kMainColor,
                            textFieldType: TextFieldType.NAME,
                              decoration:  InputDecoration(
  labelText: 'LastName',
  hintText: 'LastName',
  errorText: lastNameError,
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

                         const SizedBox(
                          height: 12.0,
                        ),
                        Padding(
                           padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: AppTextField(
                            controller: passwordController,
                             cursorColor: kMainColor,

                            textFieldType: TextFieldType.PASSWORD,
                              decoration:  InputDecoration(
  labelText: 'Password',
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
    color: kTitleColor, // Color when the TextField is focused
  ),
),
                          ),
                        ),
                         const SizedBox(
                          height: 20.0,
                        ),
                        isLoading
                            ? const LoadingWidget(
                                color: kMainColor,
                                size: 10.0,
                                spacing: 10.0,
                              )
                            
                            :
                        ButtonGlobal(
                          buttontext: 'Continue',
                          buttonDecoration:
                          kButtonDecoration.copyWith(color: kMainColor),
                         onPressed: () {         
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
  });

  if (emailError == null && firstNameError == null && lastNameError == null && passwordError == null) {
    createUserAccount() ;  
  }
},
                          
                        ),
                                 const SizedBox(height: 10),
              Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Or Log with your account here   ',
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
  MaterialPageRoute(builder: (context) => SignIn()),
);
        },
        child:const Text(
          'LogIn',
          style: TextStyle(
            fontSize: 15.0,
            color: kSecondaryColor,
            fontWeight: FontWeight.bold,
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
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
