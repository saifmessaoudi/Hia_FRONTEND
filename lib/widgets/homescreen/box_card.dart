import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/services/offer.service.dart';
import 'package:hia/utils/count_down_timer.dart';  // <-- Make sure this has "CountdownTimer"
import 'package:hia/views/details/box_details_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SurpriseBoxCard extends StatelessWidget {
  const SurpriseBoxCard({
    Key? key,
    required this.offer,
    this.isGrid = false,
  }) : super(key: key);

  final Offer offer;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isGrid ? 200.w : 280.w, // Adjust width for grid
      height: isGrid ? 210.h : 248.h, // Adjust height for grid
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoxDetailsScreen(box: offer),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.background.withOpacity(0.1),
                offset: const Offset(0, 5),
                blurRadius: 1,
                spreadRadius: 1,
                blurStyle: BlurStyle.inner,
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------
              // Top Image Section
              // -------------------
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      width: double.infinity,
                      height: isGrid ? 120.h : 150.h, // Adjust image height for grid
                      imageUrl: offer.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer(
                        child: Container(
                          height: isGrid ? 120.h : 150.h,
                          width: double.infinity,
                          color: AppColors.background,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: isGrid ? 40.h : 50.h,
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
                    // Name overlay
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          offer.name,
                          style: AppStyles.interboldHeadline1
                              .withSize(isGrid ? 18.sp : 21.sp)
                              .withColor(Colors.white)
                              .bold(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),

              // -------------------
              // Bottom Details
              // -------------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Establishment Row
                    Row(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: offer.etablishment.image ?? '',
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer(
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                color: AppColors.background,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const SizedBox(width: 24, height: 24),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          offer.etablishment.name,
                          style: AppStyles.interboldHeadline1
                              .withSize(isGrid ? 13.sp : 15.sp)
                              .withColor(AppColors.background),
                        ),
                      ],
                    ),
                    const Gap(6),

                    // Countdown Timer (with textStyle)
                    CountdownTimer(
                      endTime: offer.validUntil, // Must be a DateTime
                      offerId: offer.id,
                      offerService: OfferService(), // or your provider-based instance
                      textStyle: AppStyles.interregularTitle
                          .withSize(isGrid ? 10.sp : 13.sp)
                          .withColor(AppColors.blackTitleButton),
                    ),

                    const Gap(6),

                    // Row with quantity + price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: AppColors.background,
                              size: isGrid ? 13 : 16,
                            ),
                            const Gap(4),
                            Text(
                              "reste ${offer.quantity} box",
                              style: AppStyles.interregularTitle
                                  .withSize(isGrid ? 10.sp : 13.sp)
                                  .withColor(AppColors.background)
                                  .bold(),
                            ),
                          ],
                        ),
                        // Price
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${offer.price.toStringAsFixed(2)} ',
                                style: AppStyles.interboldHeadline5
                                    .withSize(isGrid ? 10.sp : 15.sp)
                                    .withColor(AppColors.blackTitleButton)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'TND',
                                style: AppStyles.interboldHeadline5
                                    .withSize(isGrid ? 8.sp : 10.sp)
                                    .withColor(AppColors.blackTitleButton)
                                    .copyWith(fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
