import 'package:flutter/material.dart';
import 'package:hia/viewmodels/food_viewmodel.dart';
import 'package:hia/views/foods/food_search_delegate.dart';
import 'package:hia/views/foods/food_search_delegate_establishment.dart';
import 'package:hia/widgets/homescreen/food_card.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../constant.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {

  @override
  Widget build(BuildContext context) {
    final foodViewModel = Provider.of<FoodViewModel>(context, listen: false);

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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ).onTap(() {
                          Navigator.pop(context);
                        }),
                      ),
                      Text(
                        'Popular Deals',
                        style: kTextStyle.copyWith(
                            color: Colors.white, fontSize: 18.0),
                      ),
                      const SizedBox(width: 130,),
                      IconButton(
                        icon: const Icon(Icons.search,color: Colors.white,),
                        onPressed: () async {
                          final selected = await showSearch(
                            context: context,
                            delegate: FoodSearchDelegateEstablishment(Provider.of<FoodViewModel>(context, listen: false),), // Replace with your custom SearchDelegate
                          );
                          // Handle search results if needed
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.75,
                            crossAxisCount: 2,
                            children: List.generate(
                              foodViewModel.foods.length,
                              (index) => Center(
                                child: FoodCard(
                                  food: foodViewModel.foods[index],
                                ).onTap(() {
                                  // Handle tap
                                }),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
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
