import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/utils/loading_widget.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/views/foodPreference/food_pref_provider.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/constant.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';

class FoodPreferencePage extends StatefulWidget {
  const FoodPreferencePage({super.key});

  @override
  _FoodPreferencePageState createState() => _FoodPreferencePageState();
}

class _FoodPreferencePageState extends State<FoodPreferencePage> {
  final List<Map<String, String>> preferences = [
    {"name": "Fast Food", "image": "images/fastfood.jpg"},
    {"name": "Vegan", "image": "images/vegan.jpg"},
    {"name": "Sugar", "image": "images/sugar.jpg"},
    {"name": "Nut-Free", "image": "images/fastfood.jpg"},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePreferences();
    });
  }

  void _initializePreferences() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
    final foodPreferenceProvider =
        Provider.of<FoodPreferenceProvider>(context, listen: false);

    foodPreferenceProvider.initializePreferences(userViewModel.foodPreference);
  }

  @override
  Widget build(BuildContext context) {
    final foodPreferenceProvider = Provider.of<FoodPreferenceProvider>(context);

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
                const Padding(
                  padding: EdgeInsets.all(40.0),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text(
                            'Choose Your Food Preferences',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          child: GridView.builder(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 20.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: preferences.length,
                            itemBuilder: (context, index) {
                              String prefName = preferences[index]['name']!;
                              String prefImage = preferences[index]['image']!;
                              bool isSelected = foodPreferenceProvider
                                  .selectedPreferences[prefName]!;

                              return GestureDetector(
                                onTap: () {
                                  foodPreferenceProvider
                                      .togglePreference(prefName);
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: isSelected
                                          ? kMainColor.withOpacity(0.3)
                                          : Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(10.0)),
                                          child: Image.asset(
                                            prefImage,
                                            height: 130,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  prefName,
                                                  style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Checkbox(
                                                activeColor: kMainColor,
                                                value: isSelected,
                                                onChanged: (bool? value) {
                                                  foodPreferenceProvider
                                                      .togglePreference(
                                                          prefName);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                                    
                      ButtonGlobal(
                            buttontext: foodPreferenceProvider.isLoading
                                ? 'Saving...'
                                : 'Save Preferences',
                            buttonDecoration:
                                kButtonDecoration.copyWith(color: kMainColor),
                            onPressed: () {
                              final userViewModel =
                          Provider.of<UserViewModel>(context, listen: false);
                          final establishementViwModel = Provider.of<EstablishmentViewModel>(context, listen: false);
                      userViewModel.initSession();
                              foodPreferenceProvider.savePreferences();
                             userViewModel.fetchUserById(userViewModel.userId!);
                             establishementViwModel.fetchEstablishments();

                            showCustomToast(context, 'Preferences saved successfully');
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                                (Route<dynamic> route) => false,
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Your preferences will help us recommend the best food for you.',
                            textAlign: TextAlign.center,
                            style: kTextStyle.copyWith(
                              color: kGreyTextColor,
                            ),
                          ),
                        ),
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
