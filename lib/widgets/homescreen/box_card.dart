import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/views/details/box_details_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SurpriseBoxCard extends StatelessWidget {
  const SurpriseBoxCard({super.key, required this.offer, this.isGrid = false});

  final Offer offer;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isGrid ? 200.w : 280.w, // Adjust width for grid
      height: isGrid ? 210.h : 230.h, // Adjust height for grid
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
              // Top Section with Image and Title
              ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Stack(
                  children: [
                    FastCachedImage(
                      url: offer.image,
                      height: isGrid
                          ? 120.h
                          : 140.h, // Adjust image height for grid
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, loadingProgress) {
                        return loadingProgress.isDownloading &&
                                loadingProgress.totalBytes != null
                            ? Shimmer(
                                child: Container(
                                  height: isGrid
                                      ? 120.h
                                      : 140.h, // Adjust shimmer height for grid
                                  width: double.infinity,
                                  color: AppColors.unselectedItemShadow,
                                ),
                              )
                            : SizedBox(
                                height: isGrid
                                    ? 120
                                    : 140); // Adjust height for grid
                      },
                    ),
                    // Gradient Overlay at the bottom of the image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: isGrid
                            ? 40.h
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
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          offer.name,
                          style: AppStyles.interboldHeadline1
                              .withSize(isGrid
                                  ? 18.sp
                                  : 21.sp) // Adjust font size for grid
                              .withColor(Colors.white)
                              .bold(),
                        ),
                      ),
                    ),
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
                        ClipOval(
                          child: FastCachedImage(
                            url: offer.etablishment.image!,
                            width:
                                24.w, 
                            height: 24.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, loadingProgress) {
                              return loadingProgress.isDownloading &&
                                      loadingProgress.totalBytes != null
                                  ? Shimmer(
                                      child: Container(
                                        width: 24.w,
                                        height: 24.h,
                                        color: AppColors.unselectedItemShadow,
                                      ),
                                    )
                                  : const SizedBox(width: 24, height: 24);
                            },
                          ),
                        ),
                        SizedBox(
                            width: 8.w), 
                        Text(
                          offer.etablishment.name,
                          style: AppStyles.interboldHeadline1
                              .withSize(isGrid
                                  ? 13.sp
                                  : 15.sp) // Adjust font size for grid
                              .withColor(AppColors.background),
                        ),
                      ],
                    ),
                    const Gap(6),
                    Text(
                      "Valid until ${offer.formattedValidUntil}",
                      style: AppStyles.interregularTitle
                          .withSize(isGrid
                              ? 10.sp
                              : 13.sp) // Adjust font size for grid
                          .withColor(AppColors.blackTitleButton),
                    ),
                    const Gap(6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                color: AppColors.background,
                                size: isGrid
                                    ? 13
                                    : 16), // Adjust icon size for grid
                            const Gap(4),
                            Text(
                              "only ${offer.quantity} left",
                              style: AppStyles.interregularTitle
                                  .withSize(isGrid
                                      ? 10.sp
                                      : 13.sp) // Adjust font size for grid
                                  .withColor(AppColors.background)
                                  .bold(),
                            ),
                          ],
                        ),
                        // Price
                        Text(
                          '${offer.price.toStringAsFixed(2)} TND',
                          style: AppStyles.interboldHeadline5
                              .withSize(isGrid
                                  ? 10.sp
                                  : 13.sp) // Adjust font size for grid
                              .withColor(AppColors.blackTitleButton),
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
