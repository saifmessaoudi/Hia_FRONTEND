import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/views/details/establishment.details.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class FoodDetailsScreen extends StatefulWidget {
  const FoodDetailsScreen({required this.food});

  final Food food;

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
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
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 100.0,
                            ),
                            SizedBox(
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
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity += 1;
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
                            ),
                            const Gap(20),
                             Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EstablishmentDetailsScreen(establishment: widget.food.establishment)));
                                },
                                child: Text(
                                  widget.food.establishment.name,
                                  style: kTextStyle.copyWith(
                                    color: kMainColor,
                                    fontSize: 17.0,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(20),
                            RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.lock_clock,
                                              color: widget.food.isAvailable ? kMainColor : Colors.red,
                                              size: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: widget.food.isAvailable ? ' Available' : ' Not Available',
                                            style: kTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kTitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            const Gap(20),
                             Text(
                                    widget.food.name,
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                    ),
                                  ),
                            const SizedBox(
                              height: 10.0,
                            ),
                              Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Row(
                                children: [
                                 
                                  const Gap(10),
                                  Text(
                                    '${widget.food.price} TND',
                                    style: kTextStyle.copyWith(
                                      color: kMainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const Spacer(),
                                  RichText(
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
                                          text: widget.food.averageRating
                                              .toString(),
                                          style: kTextStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: kTitleColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(30),
                                  RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons.reviews,
                                                color: kTitleColor,
                                                size: 18.0,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "${widget.food.reviews!.length }  Reviews", 
                                              style: kTextStyle.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: kTitleColor,
                                              ),
                                            ),
                                          ],
                                        ),
  ),

                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Text(
                                widget.food.description,
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            //title center ingredients 
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Ingredients',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      // Implement show all ingredients logic
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Show All',
                                          style: kTextStyle.copyWith(
                                            color: kMainColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        const Icon(
                                          FontAwesomeIcons.chevronRight,
                                          color: kMainColor,
                                          size: 12.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Row(
                                children: widget.food.ingredients.map((ingredient) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Chip(
                                      label: Text(
                                        ingredient,
                                        style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          
                          //aa to cart

                             ButtonGlobal(
                                buttontext: 'Add to Cart',
                                buttonDecoration: kButtonDecoration.copyWith(
                                  color: kMainColor,
                                ),
                                onPressed: () {
                                  // Implement add to cart logic
                                },
                              ),     
                          
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: MediaQuery.of(context).size.width / 4,
                      child: Image.asset(widget.food.image),
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
