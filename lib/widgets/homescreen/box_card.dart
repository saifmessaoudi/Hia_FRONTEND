import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/services/offer.service.dart';
import 'package:hia/utils/count_down_timer.dart';  // <-- Make sure this has "CountdownTimer"
import 'package:hia/viewmodels/offer.viewmodel.dart';
import 'package:hia/views/details/box_details_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:provider/provider.dart';


class SurpriseBoxCard extends StatefulWidget {
  const SurpriseBoxCard({
    Key? key,
    required this.offer,
    this.isGrid = false,
  }) : super(key: key);

  final Offer offer;
  final bool isGrid;

  @override
  State<SurpriseBoxCard> createState() => _SurpriseBoxCardState();
}

class _SurpriseBoxCardState extends State<SurpriseBoxCard> {
  @override
  void initState() {
    super.initState();
    _checkQuantity();
  }

  @override
  void didUpdateWidget(SurpriseBoxCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.offer.quantity != widget.offer.quantity) {
      _checkQuantity();
    }
  }

  void _checkQuantity() {
    if (widget.offer.quantity <= 0) {
      Debugger.yellow('Offer ${widget.offer.id} quantity is zero, triggering removal');
      final offerViewModel = Provider.of<OfferViewModel>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        offerViewModel.forceDeleteOffer(widget.offer.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OfferViewModel>(
      builder: (context, offerViewModel, child) {
        if (widget.offer.quantity <= 0) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: widget.isGrid ? 200.w : 280.w,
          height: widget.isGrid ? 210.h : 248.h,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoxDetailsScreen(box: widget.offer),
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
                          height: widget.isGrid ? 120.h : 150.h, // Adjust image height for grid
                          imageUrl: widget.offer.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer(
                            child: Container(
                              height: widget.isGrid ? 120.h : 150.h,
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
                            height: widget.isGrid ? 40.h : 50.h,
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
                              widget.offer.name,
                              style: AppStyles.interboldHeadline1
                                  .withSize(widget.isGrid ? 18.sp : 21.sp)
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
                                imageUrl: widget.offer.etablishment.image ?? '',
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
                              widget.offer.etablishment.name,
                              style: AppStyles.interboldHeadline1
                                  .withSize(widget.isGrid ? 13.sp : 15.sp)
                                  .withColor(AppColors.background),
                            ),
                          ],
                        ),
                        const Gap(6),

                        // Countdown Timer (with textStyle)
                        CountdownTimer(
                          endTime: widget.offer.validUntil, // Must be a DateTime
                          offerId: widget.offer.id,
                          offerService: OfferService(), // or your provider-based instance
                          textStyle: AppStyles.interregularTitle
                              .withSize(widget.isGrid ? 10.sp : 13.sp)
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
                                  size: widget.isGrid ? 13 : 16,
                                ),
                                const Gap(4),
                                Text(
                                  "reste ${widget.offer.quantity} box",
                                  style: AppStyles.interregularTitle
                                      .withSize(widget.isGrid ? 10.sp : 13.sp)
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
                                    text: '${widget.offer.price.toStringAsFixed(2)} ',
                                    style: AppStyles.interboldHeadline5
                                        .withSize(widget.isGrid ? 10.sp : 15.sp)
                                        .withColor(AppColors.blackTitleButton)
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: 'TND',
                                    style: AppStyles.interboldHeadline5
                                        .withSize(widget.isGrid ? 8.sp : 10.sp)
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
      },
    );
  }
}
