import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/views/details/box_details_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SurpriseBoxCard extends StatelessWidget {
  const SurpriseBoxCard({super.key, required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height:160,
      child: GestureDetector(
       onTap: () {
          Navigator.push (
            context,
            MaterialPageRoute(
              builder: (context) => BoxDetailsScreen(box: offer),
            ),
          );
        },
        child: Container(
           decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                boxShadow:  [
                    BoxShadow(
                    color:   AppColors.background.withOpacity(0.1),
                    offset: const Offset(0, 5),
                    blurRadius: 1,
                    spreadRadius: 1,
                    blurStyle: BlurStyle.inner,
                  ),
                ],
              ),
          child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FastCachedImage(
                      url: offer.image,
                      fit:  BoxFit.cover,
                      loadingBuilder: (context, loadingProgress) {
                        return loadingProgress.isDownloading && loadingProgress.totalBytes != null
                            ? Shimmer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                                    color: AppColors.unselectedItemShadow,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    Center(
                      child: Text(offer.name, style: AppStyles.interboldHeadline1.withSize(23).withColor(Colors.white).medium()),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
