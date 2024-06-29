import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/establishement.model.dart';


import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/global_components/category_data.dart';
import 'package:hia/views/home/BookTableCard.dart';
import 'package:hia/views/home/establishment_details.dart';
import 'package:hia/views/home/establishment_screen.dart';
import 'package:hia/views/home/establishment_search_delegate.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';




//import 'product_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? address = '';
  int? lengthestablishmentListByPoisition  ;
 List<Establishment>? establishmentsByPosition;
 double? distancebetweenuserandestablishment ; 
  @override
  void initState() {
    super.initState();
    // Fetch the user data from the provider
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);

       //  userViewModel.fetchUserById(userViewModel.userId!);

    setState(() {
      address = userViewModel.address;
      lengthestablishmentListByPoisition = establishmentViewModel.lengthEstablishments ;
      establishmentsByPosition = establishmentViewModel.establishments ;
      distancebetweenuserandestablishment = establishmentViewModel.distance ; 
    });

    // Fetch establishments data from the provider
    establishmentViewModel.establishments; // Assuming this method fetches establishments
  }

 @override
Widget build(BuildContext context) {
  final establishmentViewModel = Provider.of<EstablishmentViewModel>(context);

  return SafeArea(
    child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width,
                    height: 240.0,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/hiahomehead.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hia Tunisia',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            color: Color.fromARGB(255, 216, 248, 210),
                                            size: 15.0,
                                          ),
                                        ),
                                        TextSpan(
                                         text: address ?? '',
                                          style: kTextStyle.copyWith(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 255, 255, 255),
                              radius: 20.0,
                              child: Icon(
                                Icons.notifications_none_outlined,
                                color: kMainColor,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F5F2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      showSearch(
                                        context: context,
                                        delegate: EstablishmentSearchDelegate(
                                          Provider.of<EstablishmentViewModel>(context, listen: false),
                                        ),
                                      );
                                    },
                                    child: AppTextField(
                                      textFieldType: TextFieldType.NAME,
                                      enabled: false,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: kTitleColor,
                                        ),
                                        border: InputBorder.none,
                                        fillColor: Color(0xFFF7F5F2),
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText: 'Search',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Image(image: AssetImage('images/filter.png')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearly establishments:',
                    style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: 16.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProductScreen(
                              
                            ),
                          ),
                        );                    },
                    child: Text(
                      'See All',
                      style: kTextStyle.copyWith(
                        color: kMainColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
             Consumer<EstablishmentViewModel>(
    builder: (context, establishmentViewModel, child) {
      return establishmentViewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: kMainColor,
              ),
            )
          : establishmentViewModel.establishments != null && establishmentViewModel.establishments!.isNotEmpty
              ? HorizontalList(
                  spacing: 10,
                  itemCount: establishmentViewModel.establishments!.length,
                  itemBuilder: (_, i) {
                    establishmentViewModel.calculateDistance(i);
                    return BookTableCard(
                      restaurantData: establishmentViewModel.establishments![i],
                      index: i,
                    ).onTap(
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(
                              product: establishmentViewModel.establishments![i],
                              index: i,
                            ),
                          ),
                        );
                      },
                      highlightColor: context.cardColor,
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'There is no available data',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
    },
  ),
          ],
        ),
      ),
    ),
  );
}


}

