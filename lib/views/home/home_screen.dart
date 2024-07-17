import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:hia/constant.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/viewmodels/food_viewmodel.dart';
import 'package:hia/viewmodels/offer.viewmodel.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/details/box_details_screen.dart';
import 'package:hia/views/details/establishment.details.dart';
import 'package:hia/views/details/food_details_screen.dart';
import 'package:hia/views/foods/foods_see_all_screen.dart';
import 'package:hia/views/global_components/category_data.dart';
import 'package:hia/widgets/filter_dialog.dart';
import 'package:hia/widgets/homescreen/box_card.dart';
import 'package:hia/widgets/homescreen/establishment_card.dart';
import 'package:hia/widgets/homescreen/food_card.dart';
import 'package:hia/widgets/smart_scaffold.dart';
import 'package:hia/views/home/BookTableCard.dart';
import 'package:hia/views/home/establishment_details.dart';
import 'package:hia/views/home/establishment_screen.dart';
import 'package:hia/views/home/establishment_search_delegate.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';




//import 'product_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> banner = ['images/banner1.png', 'images/banner2.png'];



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SmartScaffold(
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
                          image: AssetImage(
                            'images/hiahomehead.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/h_logo_white.png',
                                      height: 40.0,
                                      width: 40.0,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Consumer<UserViewModel>(
                                      builder: (context, userViewModel, child) {
                                        return RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.location_on_outlined,
                                                  color: white,
                                                  size: 15.0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: userViewModel.userData?.address ?? '',
                                                style: kTextStyle.copyWith(
                                                  color: white,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
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
                                 Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Image(
                              image: AssetImage('images/filter.png'),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return FilterDialog(
                                    onApply: (selectedFilters) {
                                      Provider.of<FoodViewModel>(context, listen: false).applyFilters(selectedFilters);
                                    },
                                  );
                                },
                              );
                            },
                          ),
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

                  Consumer<FoodViewModel>(
                            builder: (context, foodViewModel, child) {
                              return foodViewModel.selectedFilters.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Wrap(
                                        spacing: 8.0,
                                        children: foodViewModel.selectedFilters.map((filter) {
                                          return Chip(
                                        backgroundColor: kMainColor,
                                        label: Text( filter , style: kTextStyle.copyWith(color: Colors.white, fontSize: 12.0)),

                                          );
                                        }).toList(),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                                   
                
                
              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<OfferViewModel>(
                  builder: (context, offerViewModel, child) {
                    return offerViewModel.isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SizedBox(
                              height: 170, // Specify a fixed height for the ListView
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (_, __) => Container(
                                  width: 300,
                                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : HorizontalList(
                            spacing: 10,
                            itemCount: offerViewModel.offers.length,
                            itemBuilder: (_, i) {
                              return SurpriseBoxCard(
                                offer: offerViewModel.offers[i],
                              ).onTap(
                                () {
                                  Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) =>  BoxDetailsScreen(box: offerViewModel.offers[i],),
                                         ),
                                       );
                                },
                                highlightColor: context.cardColor,
                              );
                            },
                          );
                  },
                  
                ),
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
    // Check if data is loading or sorting
    if (establishmentViewModel.isLoading || establishmentViewModel.isSorting) {
      return const Center(
        child: CircularProgressIndicator(
          color: kMainColor,
        ),
      );
    }

    // Check if establishments are available
    if (establishmentViewModel.establishments != null && establishmentViewModel.establishments.isNotEmpty) {
      return HorizontalList(
        spacing: 10,
        itemCount: establishmentViewModel.establishments.length,
        itemBuilder: (_, i) {
          establishmentViewModel.calculateDistance(establishmentViewModel.establishments[i]);

          // Check if distances are available
          if (establishmentViewModel.distances == null || establishmentViewModel.distances!.length <= i) {
            return const Center(
              child: CircularProgressIndicator(
                color: kMainColor,
              ),
            );
          }

          return BookTableCard(
            restaurantData: establishmentViewModel.establishments[i],
            index: i,
          ).onTap(
            () {
              establishmentViewModel.fetchFoodsFromEstablishment(i);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetails(
                    product: establishmentViewModel.establishments[i],
                    index: i,
                  ),
                ),
              );
            },
            highlightColor: context.cardColor,
          );
        },
      );
    }

    // Default message if no data is available
    return const Center(
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


      
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Recommended for you',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontSize: 18.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'See all',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ).onTap(() {
                      //const ProductScreen().launch(context);
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<EstablishmentViewModel>(
                  builder: (context, establishmentViewModel, child) {
                    return establishmentViewModel.isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SizedBox(
                              height: 170, // Specify a fixed height for the ListView
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (_, __) => Container(
                                  width: 300,
                                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : HorizontalList(
                            spacing: 10,
                            itemCount: establishmentViewModel.establishments.length,
                            itemBuilder: (_, i) {
                              return EstablishmentCard(establishment: establishmentViewModel.establishments[i]).onTap(
                                () {
                                 //navigate 
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  EstablishmentDetailsScreen(establishment: establishmentViewModel.establishments[i],),
                                      ),
                                    );
                                },
                                highlightColor: context.cardColor,

                              );
                            }
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Poular Deals',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontSize: 18.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'See all',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ).onTap(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FoodScreen(),
                        ),
                      );                    }),
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<FoodViewModel>(
                  builder: (context, foodViewModel, child) {
                    return foodViewModel.isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SizedBox(
                              height: 170, // Specify a fixed height for the ListView
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (_, __) => Container(
                                  width: 300,
                                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : 
                        HorizontalList(
                            spacing: 10,
                            itemCount: foodViewModel.foods.length,
                            itemBuilder: (_, i) {
                              return FoodCard(food: foodViewModel.foods[i]).onTap(
                                () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) =>  FoodDetailsScreen(food: foodViewModel.foods[i],),
                                         ),
                                       );
                                },
                                highlightColor: context.cardColor,
                              );
                            },
                          );
                        

                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Poular Deals',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontSize: 18.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'See all',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ).onTap(() {
                      
                    }),
                  ],
                ),
              ),
              const Gap(20.0),
        
            ],
          ),
        ),
      ),
    );
  }
}




