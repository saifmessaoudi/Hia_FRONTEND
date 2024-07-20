// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/views/details/food_details_screen.dart';
import 'package:hia/views/foods/food_see_all_screen_establishment.dart';
import 'package:hia/views/foods/foods_see_all_screen.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/widgets/homescreen/food_card.dart';



import 'package:nb_utils/nb_utils.dart' as nb_utils;
import 'package:nb_utils/nb_utils.dart';

import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({required this.product, required this.index});

  final Establishment product;
  final int index ; 
  static const IconData contact_phone = IconData(0xe18c, fontFamily: 'MaterialIcons');

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
            final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);

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
            SingleChildScrollView(
               
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
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
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            radius: 16.0,
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                              size: 16.0,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      
                      Container(
                        width: context.width(),
                        height: context.height()+300,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 100.0,
                            ),
                            /*SizedBox(
                              width: 100.0,
                              height: 50.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kMainColor,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity > 1
                                              ? quantity -= 1
                                              : quantity = 1;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Text(
                                        quantity.toString(),
                                        style: kTextStyle.copyWith(
                                            color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity > 0
                                              ? quantity += 1
                                              : quantity = 1;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),*/
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: IconButton(
                                  icon: Icon(Icons.phone_in_talk_sharp, color: const Color.fromARGB(255, 0, 26, 48)),
                                  onPressed: () async {
                                    String phoneNumber = 'tel:${widget.product.phone}';
                                    if (await canLaunch(phoneNumber)) {
                                      await launch(phoneNumber);
                                    } else {
                                      throw 'Could not launch $phoneNumber';
                                    }
                                  },
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    widget.product.name,
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                   Row(
      children: [
        
        const SizedBox(width: 15),
        Text(
          widget.product.isOpened ? 'Opened' : 'Closed',
          style: kTextStyle.copyWith(
            color: widget.product.isOpened ? kMainColor : Colors.red,
             fontWeight: FontWeight.bold,
            
          ),
        ),
        const SizedBox(width: 7),
        Icon(
          Icons.access_time,
          color: widget.product.isOpened ? kMainColor : const Color.fromARGB(255, 114, 26, 19),
          size: 16,
        ),
      ],
    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 20.0,
                                  top: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RichText(
   text: TextSpan(
      children: [
        const WidgetSpan(
          child: Icon(
            Icons.location_on,
            color: kMainColor,
            size: 18.0,
          ),
        ),
        TextSpan(
          text: "${establishmentViewModel.distances![widget.index].toStringAsFixed(1)} km", 
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: kTitleColor,
          ),
        ),
      ],
    ),
  ),
                                  ),
                                  
                               Expanded(
  child: RichText(
    text: TextSpan(
      children: [
        const WidgetSpan(
          child: Icon(
            Icons.star,
            color: Colors.amber,
            size: 18.0,
          ),
        ),
        TextSpan(
          text: widget.product.averageRating.toString(), 
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: kTitleColor,
          ),
        ),
      ],
    ),
  ),
),
Expanded(
  child: Padding(
    padding: const EdgeInsets.only(
                                  left: 15.0,
                                  ),
    
  child: RichText(
    text: TextSpan(
      children: [
        const WidgetSpan(
          child: Icon(
            Icons.reviews,
            color: Color.fromARGB(255, 5, 32, 54),
            size: 18.0,
          ),
        ),
        TextSpan(
          text: "${widget.product.reviews?.length}  Reviews", 
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: kTitleColor,
          ),
        ),
      ],
    ),
  ),
),
),


                                  /*Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              FontAwesomeIcons.clock,
                                              color: kMainColor,
                                              size: 18.0,
                                            ),
                                          ),
                                         /* TextSpan(
                                            text:
                                                '${widget.product.productTime} Min',
                                            style: kTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kTitleColor,
                                            ),
                                          ),
                                        ],
                                      ),*/
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                          Padding(
  padding: const EdgeInsets.all(20.0),
  child: Text(
    widget.product.description ?? '',
    style: kTextStyle.copyWith(color: kTitleColor),
  ),
),

                            const SizedBox(height: 20.0,),
                            Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Our Products :',
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
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => FoodSeeAllScreenEstablishment(product: widget.product),
  ),
);
                   }),
                  ],
                ),
              ),
                            
                        Padding(
  padding: const EdgeInsets.all(10.0),
  child: Consumer<EstablishmentViewModel>(
    builder: (context, viewModel, child) {
      if (viewModel.isFetchingFoods) {
        return Shimmer.fromColors(
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
        );
      } else if (viewModel.foodbyestablishment == null || viewModel.foodbyestablishment!.isEmpty) {
        return Center(
          child: Text(
            'No available products',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        );
      } else {
        return HorizontalList(
          spacing: 10,
          itemCount: viewModel.foodbyestablishment!.length,
          itemBuilder: (_, i) {
            return FoodCard(
              food: viewModel.foodbyestablishment![i],
            ).onTap(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailsScreen(
                      food: viewModel.foodbyestablishment![i],
                    ),
                  ),
                );
              },
              highlightColor: context.cardColor,
            );
          },
        );
      }
    },
  ),
),

                            
                            
                            Row(
                              children: [
                               /* Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ButtonGlobal(
                                      buttontext: 'Add To Cart',
                                      buttonDecoration:
                                          kButtonDecoration.copyWith(color: kMainColor),
                                      onPressed: (){
                                        ///const CartScreen().launch(context);
                                      },
                                    ),
                                  ),
                                ),*/
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ButtonGlobal(
                                      buttonTextColor: Colors.white,
                                      buttontext: 'Checkout',
                                      buttonDecoration:
                                      kButtonDecoration.copyWith(color: kMainColor),
                                      onPressed: (){
                                       establishmentViewModel.launchMaps(widget.product.latitude,widget.product.longitude) ; 
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                 Padding(
  padding: const EdgeInsets.only(top: 100.0),
  child: CircleAvatar(
    backgroundColor: kMainColor,
    radius: MediaQuery.of(context).size.width / 4,
    child: ClipOval(
      child: FadeInImage.assetNetwork(
        placeholder: 'images/error_image.png', // Placeholder image asset
        image: widget.product.image ?? 'images/error_image.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        fadeInDuration: Duration(milliseconds: 300),
        fadeOutDuration: Duration(milliseconds: 300),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'images/error_image.png', // Fallback image in case of error
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      ),
    ),
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
