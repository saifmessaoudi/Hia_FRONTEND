import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/widgets/shimmer_loading_image.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 160.0,
          child: Card(
            elevation: 5.0, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: kMainColor.withOpacity(0.5), 
                width: 2.0, 
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white, // Shadow color
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                           width: 100.0,
                          height: 100.0,
                          imageUrl: food.image,
                          placeholder: (context, url) => Shimmer(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey, Colors.white],
                            ),
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              color: Colors.white,
                            ),
                            ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          food.name,
                          style: kTextStyle.copyWith(color: kTitleColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: food.averageRating.toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 10.0,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          food.averageRating.toString(),
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
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
                                text: food.price.toString(),
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const CircleAvatar(
                          backgroundColor: Colors.transparent,
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
        ),
        const Positioned(
          top: 10.0,
          right: 10.0,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 16.0,
            child: Icon(
              Icons.favorite_border,
              color: kMainColor,
              size: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}
