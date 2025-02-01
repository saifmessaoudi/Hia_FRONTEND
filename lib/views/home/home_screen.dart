import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hia/viewmodels/market_viewmodel.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/views/home/sections/nearly_section.dart';
import 'package:hia/views/location/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SmartScaffold(
      body: RefreshIndicator(
        color: kMainColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          Provider.of<FoodViewModel>(context, listen: false).refreshFoods();
          Provider.of<EstablishmentViewModel>(context, listen: false)
              .refreshEstablishments();
          Provider.of<OfferViewModel>(context, listen: false).refreshOffers();
          Provider.of<MarketViewModel>(context, listen: false).refreshMarkets() ; 
        },
        child: SingleChildScrollView(
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
                      height: 280.0,
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
                                      height: 50.0,
                                      width: 50.0,
                                    ),
                                    const SizedBox(
                                      height: 13.0,
                                    ),
                                    Consumer<UserViewModel>(
                                      builder: (context, userViewModel, child) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomMapScreen(
                                                  initialPosition: LatLng(
                                                      userViewModel.userData!
                                                          .latitude
                                                          .toDouble(),
                                                      userViewModel.userData!
                                                          .longitude
                                                          .toDouble()),
                                                ),
                                              ),
                                            );
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                const WidgetSpan(
                                                  child: Icon(
                                                    Icons.location_on_outlined,
                                                    color: white,
                                                    size: 16.0,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: userViewModel
                                                      .userData?.address,
                                                  style: kTextStyle.copyWith(
                                                    color: white,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                            Provider.of<EstablishmentViewModel>(
                                                context,
                                                listen: false),
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
                                    icon: const Image(
                                      image: AssetImage('images/filter.png'),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return FilterDialog(
                                            initialSelectedFilters:
                                                Provider.of<FoodViewModel>(
                                                        context,
                                                        listen: false)
                                                    .selectedFilters,
                                            onApply: (selectedFilters) {
                                              Provider.of<FoodViewModel>(context,
                                                      listen: false)
                                                  .applyFilters(
                                                      selectedFilters);
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
                  List<FilterData> selectedFilterData = foodViewModel
                      .selectedFilters
                      .map((filter) => catData.firstWhere((data) =>
                          data.catTitle.toLowerCase() ==
                          filter.toLowerCase()))
                      .toList();
                  bool hasFilters = selectedFilterData.isNotEmpty;

                  return Column(
                    children: [
                      if (hasFilters)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: [
                              Wrap(
                                spacing: 14.0,
                                children: selectedFilterData.map((filterData) {
                                  return FilterChipElement(
                                    catList: filterData,
                                    onRemove: () {
                                      foodViewModel
                                          .removeFilter(filterData.catTitle);
                                    },
                                  );
                                }).toList(),
                              ),
                              Gap(5.h),
                              const Divider(),
                              Gap(5.h),
                            ],
                          ),
                        ),
                      if (hasFilters) const PopularDealsSection(),
                      Consumer<OfferViewModel>(
                        builder: (context, offerViewModel, child) {
                          return offerViewModel.offers.isNotEmpty
                              ? const OffersSection()
                              : const SizedBox.shrink();
                        },
                      ),
                      const NearlySection(),
                      const RecommendedSection(),
                      if (!hasFilters) const PopularDealsSection(),
                      const Gap(20.0),
                    ],
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