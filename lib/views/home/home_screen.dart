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
import 'package:hia/widgets/filter_dialog.dart';
import 'package:hia/widgets/homescreen/box_card.dart';
import 'package:hia/widgets/homescreen/establishment_card.dart';
import 'package:hia/widgets/homescreen/filter/filter_chip.dart';
import 'package:hia/widgets/homescreen/filter/filter_data.dart';
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

  @override
void initState() {
  super.initState();
  // Trigger distance calculation on initialization
  final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
  establishmentViewModel.calculateAllDistances();
}
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'images/h_logo_white.png',
                                      height: 55.0,
                                      width: 55.0,
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
                                                  fontSize: 14.0,
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
                                 Expanded(
                          flex: 1,
                          child: IconButton( 
                            icon: const Image( image: AssetImage('images/filter.png'),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) { return FilterDialog(
                                     initialSelectedFilters: Provider.of<FoodViewModel>(context, listen: false).selectedFilters,
                                    onApply: (selectedFilters) {  Provider.of<FoodViewModel>(context, listen: false).applyFilters(selectedFilters);
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
Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Box offers :',
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
                  Consumer<FoodViewModel>(
                            builder: (context, foodViewModel, child) {
                              List<FilterData> selectedFilterData = foodViewModel.selectedFilters
                                .map((filter) => catData.firstWhere(
                                    (data) => data.catTitle.toLowerCase() == filter.toLowerCase()))
                                .toList();
                               return selectedFilterData.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Wrap(
                                        spacing: 14.0,
                                        children: selectedFilterData.map((filterData) {
                                          return FilterChipElement(catList: filterData , onRemove:() {
                                            foodViewModel.removeFilter(filterData.catTitle);
                                          },);
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
      if (establishmentViewModel.isLoading || establishmentViewModel.isSorting || establishmentViewModel.isCalculating) {
        return const Center(
          child: CircularProgressIndicator(
            color: kMainColor,
          ),
        );
      }

      if (establishmentViewModel.establishments != null && establishmentViewModel.establishments.isNotEmpty) {
        return HorizontalList(
          spacing: 10,
          itemCount: establishmentViewModel.establishments.length,
          itemBuilder: (_, i) {
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
                establishmentViewModel.fetchFoodsFromEstablishment(establishmentViewModel.establishments[i].id);
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
                    if(establishmentViewModel.recommendedEstablishments.isEmpty) {
                      const Gap(20.0);
                      return const Center(

                        child: Text(
                          'Oops! No recommended establishments',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      
                      ); 
                    } 
                    else {
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
                            itemCount: establishmentViewModel.recommendedEstablishments.length,
                            itemBuilder: (_, i) {
                              return EstablishmentCard(establishment: establishmentViewModel.recommendedEstablishments[i]).onTap(
                                () {
                                 //navigate 
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  EstablishmentDetailsScreen(establishment: establishmentViewModel.recommendedEstablishments[i],),
                                      ),
                                    );
                                },
                                highlightColor: context.cardColor,

                              );
                            }
                          );
                    }
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


            

              
              const Gap(20.0),
            ],
          ),
        ),
      ),
    );
  }
}




