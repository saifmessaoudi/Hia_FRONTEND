import 'package:flutter/material.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/authentication/sign_in.dart';
import 'package:hia/views/profile/edit_profile.dart';
import 'package:hia/widgets/custom_dialog.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 90.0,
                  ),
                  Container(
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
                        const CircleAvatar(
                          radius: 20.0,
                          child: Image(
                            image: AssetImage('images/h_logo.png'),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Hia Team',
                          style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                        Text(
                          '+21696885412',
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0)),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            const EditProfile().launch(context);
                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.person_outline_rounded,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'My Profile',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.security_outlined,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Privacy Settings',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            // const NotificationScreen().launch(context);
                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.notifications_none,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Notification',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            // const WishList().launch(context);
                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.favorite_border_outlined,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Wishlist',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.shopping_cart_outlined,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Order Tracking',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: kGreyTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Colors.white,
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            // Show dialog when ListTile is tapped
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CustomDialog(
                                                  title:
                                                      'Are you sure you want to logout?',
                                                  content: '',
                                                  onCancel: () {
                                                    Navigator.of(context).pop(
                                                        false); // Dismiss dialog
                                                  },
                                                  onConfirm: () async {
                                                    final userViewModel =
                                                        Provider.of<
                                                                UserViewModel>(
                                                            context,
                                                            listen: false);
                                                    await userViewModel
                                                        .logout();
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SignIn()),
                                                      (Route<dynamic> route) =>
                                                          false, // Remove all routes
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.logout,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Logout',
                                            style: kTextStyle.copyWith(
                                                color: kGreyTextColor),
                                          ),
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: kGreyTextColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}