import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/models/market.model.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/views/details/box_details_screen.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';

class Marketcardgrid  extends StatelessWidget {
  const Marketcardgrid ({super.key, required this.restaurantData, this.isGrid = false , required this.index,});


  final Market restaurantData;
  final int index;
  final bool isGrid;
String _formatText(String text) {
  const int maxChars = 20; // Maximum number of characters allowed
  if (text.length > maxChars) {
    return "${text.substring(0, maxChars)}...";
  }
  return text;
}

  @override
  Widget build(BuildContext context) {
    final establishmentViewModel = Provider.of<EstablishmentViewModel>(context);
    return SizedBox(
      width: isGrid ? 180.w : 320.w, // Adjust width for grid
      height: isGrid ? 190.h : 248.h, // Adjust height for grid
     
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
              // Top Section with Image and Title
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Stack(
                  children: [
                      CachedNetworkImage(
                      width: double.infinity,
                      height: isGrid ? 90.h : 150.h, // Adjust image height for grid
                      imageUrl: restaurantData.image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer(
                        
                        
                        gradient: LinearGradient(
  colors: [
    Colors.grey.shade300, // Start color of the gradient
    Colors.grey.shade100, // End color of the gradient
  ],
  begin: Alignment.topLeft, // Starting point of the gradient
  end: Alignment.bottomRight, // Ending point of the gradient
),
                        child: Container(
                          height: isGrid ? 100.h : 150.h, // Adjust shimmer height for grid
                          width: double.infinity,
                          color: AppColors.background,
                        ),
                      ),
                      errorWidget: (context, url, error) =>const Icon(Icons.error),
                    ),
                    // Gradient Overlay at the bottom of the image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: isGrid
                            ? 30.h
                            : 50.h, // Adjust gradient height for grid
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
                    // Title Overlay on Image
                    
                  ],
                ),
              ),
              const Gap(8),

              // Bottom Section with Details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                       
                        SizedBox(
                            width: 8.w), 
                       Text(
  _formatText(restaurantData.name), // Format text to ensure ellipsis after 20 characters
  style: AppStyles.interboldHeadline1
      .withSize(isGrid ? 13.sp : 15.sp) // Adjust font size for grid
      .withColor(AppColors.background),
   // Allow text to span across two lines
  overflow: TextOverflow.visible, // Ensure text can wrap to two lines
),





                      ],
                    ),
                    const Gap(6),
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
                                  text: restaurantData.address,
                                  style: kTextStyle.copyWith(
                                      color: kGreyTextColor),
                                ),
                              ],
                            ),
                          ),
                                        const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // Adjust icon size for grid
                            const Gap(4),
                             const SizedBox(height: 6),
                      establishmentViewModel.isCalculating
                          ? const SizedBox(height: 10)
                          : RichText(
                              text: TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.location_on,
                                      color: kMainColor,
                                      size: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${establishmentViewModel.distances[index].toStringAsFixed(1)} km",
                                    style: kTextStyle.copyWith(
                                      color: kGreyTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                         Padding(
                      padding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: kMainColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          'Checkout',
                          style: kTextStyle.copyWith(color: Colors.white),
                        ),
                      ).onTap(() {
                        establishmentViewModel.launchMaps(
                            restaurantData.latitude, restaurantData.langitude);
                      }),
                    ),
                        // Price
                      
                      ],
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