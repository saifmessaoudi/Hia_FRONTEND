import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:shimmer/shimmer.dart';

class EstablishmentCard extends StatelessWidget {
  final Establishment establishment;

  EstablishmentCard({required this.establishment});

  @override
  Widget build(BuildContext context) {
    return
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 280.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          width: double.infinity,
                          height: 100.0,
                          imageUrl: establishment.image ?? "",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey, Colors.white],
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 100.0,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        // Gradient Overlay at the bottom of the image
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 40.0, // Adjust gradient height if needed
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            establishment.name,
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    color: kGreyTextColor,
                                    size: 15.0,
                                  ),
                                ),
                                TextSpan(
                                  text: establishment.city,
                                  style: kTextStyle.copyWith(
                                      color: kGreyTextColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: establishment.averageRating.toString(),
                                  style: kTextStyle.copyWith(
                                      color: kGreyTextColor),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(width: 2.0),
                                ),
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.star_rate_rounded,
                                    color: Colors.amber,
                                    size: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            establishment.isOpened ? 'Opened' : 'Closed',
                            style: kTextStyle.copyWith(
                              color: establishment.isOpened
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
  }
}