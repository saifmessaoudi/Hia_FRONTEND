import 'package:cached_network_image/cached_network_image.dart';
import 'package:hia/views/authentication/sign_in.dart';
import 'package:hia/views/foods/food_see_all_favourites.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/views/map/map_positions.dart';
import 'package:hia/views/profile/edit_profile.dart';
import 'package:hia/views/profile/order_tracking/order_history.dart';
import 'package:hia/widgets/custom_dialog.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SmartScaffold(
    
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
                   SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
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
                        Consumer<UserViewModel>(
                          builder:(context, userViewModel, child) {
                          final user = userViewModel.userData;
                          return Column(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  height: 80.0,
                                  width: 80.0,
                                  child: CachedNetworkImage(
                                    imageUrl: user?.profileImage ?? 'https://mir-s3-cdn-cf.behance.net/user/276/180d9c144450013.5cde903578dd7.jpg',
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        height: 80.0,
                                        width: 80.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                                    const SizedBox(
                                      height: 10.0,
                              ),
                              Text(
                                "Welcome, ${user?.firstName}",
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.0,
                                ),
                              ),
                              Text(
                                user?.phone  ?? '+21696885412',
                                style: kTextStyle.copyWith(color: kGreyTextColor),
                              ),
                            ],
                          );
                        },
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
                                      const MapPage().launch(context);

                                          },
                                          leading: const CircleAvatar(
                                            backgroundColor: Color(0xFFF5F5F5),
                                            child: Icon(
                                              Icons.map,
                                              color: kMainColor,
                                            ),
                                          ),
                                          title: Text(
                                            'Map',
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
                                            const FoodScreenFavourites().launch(context);
                                            
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
                                          onTap: () {
                                            const OrderHistoryScreen().launch(context);
                                          },
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
                                                   
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SignIn()),
                                                      (Route<dynamic> route) =>
                                                          false, // Remove all routes
                                                    );
                                                     await userViewModel
                                                        .logout();
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
                              ),const Gap(20),
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
      
    );
  }
}
