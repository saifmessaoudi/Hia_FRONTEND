import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/views/details/establishment.details.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/views/reviews/review_screen.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
  void initState() {
    super.initState();
    // Verify the food favorite status when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      await userViewModel.verifFoodFavourite(widget.food.id, userViewModel.userData!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    return SafeArea(
      child: SmartScaffold(
         body: Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            final isFavourite = userViewModel.getFavouriteStatus(widget.food.id);
        return Stack(
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
                          GestureDetector(
                                onTap: () async {
                                  if (isFavourite) {
                                    await userViewModel.removeFoodsFromFavourites(widget.food.id, userViewModel.userData!.id);
                                  } else {
                                    await userViewModel.addFoodsToFavourites(widget.food.id, userViewModel.userData!.id);
                                  }
                                  setState(() {}); // Refresh the state
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  radius: 20.0,
                                  child: Icon(
                                    Icons.favorite_rounded,
                                    color: isFavourite ? Colors.red : Colors.grey,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                            ],
                          ),
                          const SizedBox(height: 150),
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
                              height: 110.0,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EstablishmentDetailsScreen(
                                                  establishment: widget
                                                      .food.establishment)));
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
                                      color: widget.food.isAvailable
                                          ? kMainColor
                                          : Colors.red,
                                      size: 18.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.food.isAvailable
                                        ? ' Available'
                                        : ' Not Available',
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
                                  GestureDetector(
                                    onTap: () {
                                      // Implement show all reviews logic
                                      Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                   ReviewScreen( 
                                                    food: widget.food,
                                                  )
                                            ),
                                          );
                                    },
                                    child: RichText(
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
                                            text : '${widget.food.reviews!.length} Reviews',
                                            style: kTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kTitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children:
                                    widget.food.ingredients.map((ingredient) {
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

                            // Add to Cart Button
                            ButtonGlobal(
                              buttonTextColor: Colors.white,
                              buttontext: 'Add to Cart',
                              buttonDecoration: kButtonDecoration.copyWith(
                                color: kMainColor,
                              ),
                              onPressed: () async {
                                 cartViewModel.addItem(widget.food, 1).then((success) {
                              if (success) {
                                showCustomToast(context, "${widget.food.name} added to cart");
                              } else {
                                showCustomToast(context, "You cannot add items from different restaurants to the cart",isError: true);
                              }
                            });
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
                      backgroundColor: kMainColor,
                      radius: MediaQuery.of(context).size.width / 4,
                      child: ClipOval(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          child: CachedNetworkImage(
                            imageUrl: widget.food.image,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                         ),
                ],
              ),
            ),
          ],
        );
          }
      ),
      )
    );
  
  }
}
