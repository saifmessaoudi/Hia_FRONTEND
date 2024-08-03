import "package:hia/views/home/exports/export_homescreen.dart";


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
void initState() {
  super.initState();
   WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
     userViewModel.getFavouriteFood(userViewModel.userData!.id) ; 
    });


    
  // Trigger distance calculation on initialization
  final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
  establishmentViewModel.calculateAllDistances();
}
  List<String> banner = ['images/banner1.png', 'images/banner2.png'];






  @override
  Widget build(BuildContext context) {
    return SmartScaffold(
     
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
                                                  size: 16.0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: userViewModel.userData?.address,
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

                  Consumer<FoodViewModel>(
                            builder: (context, foodViewModel, child) {
                              List<FilterData> selectedFilterData = foodViewModel.selectedFilters
                                .map((filter) => catData.firstWhere(
                                    (data) => data.catTitle.toLowerCase() == filter.toLowerCase()))
                                .toList();
                               return selectedFilterData.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                  ////// ----------- Offers Section ----------- ///////         
                const Gap(10),
                const OffersSection(),

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
              if (establishmentViewModel.isLoading || establishmentViewModel.isSorting) {
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
               

              return BookTableCard(
                restaurantData: establishmentViewModel.establishments[i],
                  index: i,
              ).onTap(
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EstablishmentDetailsScreen(
                    establishment: establishmentViewModel.establishments[i],
                  
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


              ////// ----------- Recommended Section ----------- ///////
              
              const RecommendedSection(),

              ////// ----------- Popular Deals Section ----------- ///////
              const PopularDealsSection(),

              const Gap(20.0),
            ],
          ),
        ), 
    );
  }
}