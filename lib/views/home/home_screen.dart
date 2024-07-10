import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hia/constant.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/viewmodels/establishment_viewmodel.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/global_components/category_data.dart';
import 'package:hia/widgets/homescreen/establishment_card.dart';
import 'package:hia/widgets/smart_scaffold.dart';
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
                                const Expanded(
                                  flex: 1,
                                  child: Image(
                                    image: AssetImage('images/filter.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 220,
                    left: 30.0,
                    right: 30.0,
                    child: Row(
                      children: [
                        Text(
                          'Offers',
                          style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontSize: 18.0,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: HorizontalList(
                  spacing: 10,
                  itemCount: banner.length,
                  itemBuilder: (_, i) {
                    return Image(
                      image: AssetImage(banner[i]),
                    ).onTap(
                      () {
                        // const CourseDetails().launch(context);
                      },
                      highlightColor: context.cardColor,
                    );
                  },
                ),
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
                              return BookTableCard(establishment: establishmentViewModel.establishments[i]).onTap(
                                () {},
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
                      //const ProductScreen().launch(context);
                    }),
                  ],
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
                      //const ProductScreen().launch(context);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class FoodCard extends StatelessWidget {
  const FoodCard({
    Key? key,
    //  required this.productData
  }) : super(key: key);
  //final ProductData productData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 160.0,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                     // image: AssetImage(productData.productImage),
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),*/
                  /*  Row(
                    children: [
                      Text(
                      //  productData.productTitle,
                       // style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ],
                  ),*/
                  Row(
                    children: [
                      RatingBarIndicator(
                        //  rating: productData.productRating.toDouble(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 10.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      /*  Text(
                     //   productData.productRating,
                      //  style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),*/
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: Icon(
                                  Icons.attach_money,
                                  color: kMainColor,
                                  size: 7.0,
                                ),
                              ),
                            ),
                            TextSpan(
                              // text: productData.productPrice,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        backgroundColor: kSecondaryColor,
                        radius: 16.0,
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: kMainColor,
                          size: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE51000).withOpacity(0.1),
            radius: 16.0,
            child: const Icon(
              Icons.favorite,
              color: Color(0xFFE51000),
              size: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}

class CatCard extends StatelessWidget {
  const CatCard({Key? key, required this.catList}) : super(key: key);
  final CategoryData catList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage(catList.catIcon),
              ),
            )),
        Text(
          catList.catTitle,
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
      ],
    );
  }
}
