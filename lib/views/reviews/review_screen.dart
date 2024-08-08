import 'dart:ui';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/widgets/back_row.dart';
import 'package:icon_decoration/icon_decoration.dart';

import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:hia/app/style/widget_modifier.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/widgets/styled_button.dart';

import '../../app/style/app_colors.dart';

// ShoppingController with ChangeNotifier
class ShoppingController with ChangeNotifier {
  double _averagereview = 0.0;
  double _rating = 0.0;
  List<Map<String, dynamic>> _reviewsProduct = [];

  double get averagereview => _averagereview;
  double get rating => _rating;
  List<Map<String, dynamic>> get reviewsProduct => _reviewsProduct;

  TextEditingController commentController = TextEditingController();

  void setAverageReview(double value) {
    _averagereview = value;
    notifyListeners();
  }

  void setRating(double value) {
    _rating = value;
    notifyListeners();
  }

  void addReview(Map<String, dynamic> review) {
    _reviewsProduct.add(review);
    notifyListeners();
  }

  void addReviewToFirebase(String productId, BuildContext context) {
    // Add your logic to add review to Firebase
    // After adding review, you can clear the comment field and notify listeners
    commentController.clear();
    notifyListeners();
  }

  void cancelAddReview() {
    commentController.clear();
    notifyListeners();
  }
}

class ReviewScreen extends StatelessWidget {
  final String productId = "0";
  final Establishment establishment;
  const ReviewScreen({super.key, required this.establishment});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShoppingController(),
      child: Consumer<ShoppingController>(
        builder: (context, controller, child) {
          return SmartScaffold(
            backgroundColor: AppColors.background,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [

                             Padding(
                              //back row
                              padding: EdgeInsets.only(left: 5.w , top: 15.h),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const BackRow(title: '',),
                              ),

                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15.h),
                              child: Text(
                                
                                 "${establishment.name} Reviews",
                                style: AppStyles.interSemiBoldTextButton
                                    .withSize(FontSizes.headline4),
                              ),
                            )
                            
                           
                          ],
                        ),
                       
                        Gap(35.h),
                        Wrap(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.secondaryBackground,
                                  borderRadius: BorderRadius.circular(30.r)),
                              child: Row(
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ItemRating(
                                          ratingNumber: 5, widthRating: 151),
                                      ItemRating(
                                          ratingNumber: 4, widthRating: 106),
                                      ItemRating(
                                          ratingNumber: 3, widthRating: 60),
                                      ItemRating(
                                          ratingNumber: 2, widthRating: 19),
                                      ItemRating(
                                          ratingNumber: 1, widthRating: 6),
                                    ],
                                  ),
                                  Gap(10.w),
                                  Column(
                                    children: [
                                      Text(
                                        controller.averagereview == 0
                                            ? "N/A"
                                            :
                                        controller.averagereview
                                            .toStringAsFixed(1),
                                        style: AppStyles
                                            .interSemiBoldTextButton
                                            .bold()
                                            .withSize(FontSizes.splashTitle),
                                      ),
                                      Gap(8.h),
                                      _RatingSection(
                                        size: 14.r,
                                        fromComment: true,
                                        ignoreGestures: true,
                                        initialRating:
                                            controller.averagereview,
                                      ),
                                      Gap(8.h),
                                      Text(
                                        "${controller.reviewsProduct.length} Review",
                                        style: AppStyles
                                            .interSemiBoldTextButton
                                            .semiBold()
                                            .withSize(FontSizes.title),
                                      ),
                                    ],
                                  )
                                ],
                              ).paddingSymmetric(
                                  vertical: 20.h, horizontal: 20.w),
                            ),
                          ],
                        ),
                        Gap(14.h),
                        Column(
                          children: List.generate(
                            controller.reviewsProduct.length,
                            (index) => Reviewmodel(
                              modelReview: controller.reviewsProduct[index],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                StyledButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Stack(
                            children: [
                              ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 4.0,
                                    sigmaY: 4.0,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Color.fromARGB(126, 1, 66, 18),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 350.w,
                                  height: 549.h,
                                  decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius:
                                          BorderRadius.circular(30)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      
                                      Gap(24.h),
                                      Text(
                                        controller.rating == 0
                                            ? "N/A"
                                            :
                                        controller.rating.toStringAsFixed(1),
                                        style: AppStyles.interregularTitle
                                            .withSize(48)
                                            .copyWith(
                                                decoration: TextDecoration
                                                    .none),
                                      ),
                                      _RatingSection(
                                        size: 30.r,
                                        fromComment: true,
                                        ignoreGestures: false,
                                        initialRating: 3,
                                      ),
                                      Gap(13.h),
                                      Text(
                                        "${controller.reviewsProduct.length} reviews",
                                        textAlign: TextAlign.center,
                                        style: AppStyles
                                            .interSemiBoldTextButton
                                            .medium()
                                            .withColor(AppColors.grey)
                                            .withSize(FontSizes.headline6)
                                            .copyWith(
                                                decoration: TextDecoration
                                                    .none),
                                      ),
                                      Gap(36.h),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Add detailed review",
                                          style: AppStyles
                                              .interSemiBoldTextButton
                                              .medium()
                                              .withColor(AppColors.grey)
                                              .withSize(FontSizes.headline6)
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.none),
                                        ),
                                      ),
                                      Gap(12.h),
                                      Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          width: double.infinity,
                                          height: 103,
                                          decoration: BoxDecoration(
                                              color: AppColors.secondaryBackground,
                                              border: Border.all(
                                                  color: AppColors.background,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: TextField(
                                            style: AppStyles
                                                .interSemiBoldTextButton
                                                .medium(),
                                            keyboardType:
                                                TextInputType.multiline,
                                            controller:
                                                controller.commentController,
                                            maxLines: null,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 10.w),
                                                border: InputBorder.none,
                                                focusedBorder:
                                                    InputBorder.none,
                                                hintText: 'Enter here',
                                                hintStyle: AppStyles
                                                    .interSemiBoldTextButton
                                                    .medium()
                                                    .withColor(AppColors.offWhite)
                                                    .withSize(
                                                        FontSizes.headline6)),
                                          ),
                                        ),
                                      ),
                                      Gap(24.h),
                                      StyledButton(
                                        onPressed: () {
                                         print ("Add review");
                                        
                                        },
                                        style: ButtonStyles.primary,
                                        title: 'Submit',
                                      ),
                                      Gap(24.h),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: AppStyles
                                              .interSemiBoldTextButton
                                              .medium()
                                              .withSize(FontSizes.headline4)
                                              .copyWith(
                                                  decoration:
                                                      TextDecoration.none),
                                        ),
                                      )
                                    ],
                                  ).paddingSymmetric(
                                    horizontal: 23.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyles.primary,
                  title: 'Add review',
                ),
              ],
            ).customPadding(
                right: AppConstants.bodyMinSymetricHorizontalPadding,
                left: AppConstants.bodyMinSymetricHorizontalPadding,
                top: AppConstants.minBodyTopPadding,
                bottom: AppConstants.bodyMinBottomPadding),
          );
        },
      ),
    );
  }
}

class Reviewmodel extends StatelessWidget {
  Map<String, dynamic> modelReview;

  Reviewmodel({super.key, required this.modelReview});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            modelReview['userImage'] != ''
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FastCachedImage(
                      url: modelReview['userImage'],
                      height: 38.r,
                      width: 38.r,
                    ),
                  )
                : SizedBox(
                    height: 40.r,
                    width: 40.r,
                    child: CircleAvatar(
                      radius: AppConstants.imageRadius,
                      backgroundColor: AppColors.greenDark,
                      child: Text(
                        modelReview['username'].substring(0, 1).toUpperCase(),
                        style: AppStyles.interboldHeadline1
                            .light()
                            .withSize(20.sp),
                      ),
                    ),
                  ),
            Gap(8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modelReview['username'],
                  style: AppStyles.interSemiBoldTextButton
                      .medium()
                      .withSize(FontSizes.headline6),
                ),
                Row(
                  children: [
                    _RatingSection(
                      size: 14.r,
                      fromComment: true,
                      initialRating: modelReview['rating'],
                      ignoreGestures: true,
                    ),
                    Text(
                      modelReview['time'].toString(),
                      style: AppStyles.interSemiBoldTextButton
                          .medium()
                          .withSize(FontSizes.title),
                    )
                  ],
                )
              ],
            )
          ],
        ),
        Gap(12.h),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            modelReview['comment'],
            textAlign: TextAlign.start,
            style: AppStyles.interSemiBoldTextButton
                .medium()
                .withSize(FontSizes.headline6),
          ),
        ),
        Gap(24.h),
        Container(
          width: double.infinity,
          height: 1.h,
          decoration: const BoxDecoration(color: AppColors.primary),
        )
      ],
    ).marginSymmetric(vertical: 10.h);
  }
}

class _RatingSection extends StatelessWidget {
  _RatingSection(
      {required this.size,
      this.fromComment,
      this.initialRating,
      required this.ignoreGestures});
  final double size;
  final double? initialRating;
  bool ignoreGestures = false;
  bool? fromComment = false;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: fromComment == true ? initialRating!.toDouble() : 4,
      itemSize: size,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemPadding: EdgeInsets.only(right: 5.w),
      itemCount: 5,
      ignoreGestures: ignoreGestures,
      ratingWidget: RatingWidget(
        full: DecoratedIcon(
          icon: const Icon(
            Icons.star,
            color: AppColors.yellow,
          ),
          decoration: IconDecoration(
            border: IconBorder(
              color: AppColors.yellow,
              width: 2.w,
            ),
          ),
        ),
        half: DecoratedIcon(
          icon: const Icon(
            Icons.star,
            color: AppColors.yellow,
          ),
          decoration: IconDecoration(
            border: IconBorder(
              color: AppColors.yellow,
              width: 2.w,
            ),
          ),
        ),
        empty: DecoratedIcon(
          icon: const Icon(
            Icons.star,
            color: AppColors.secondaryBackground,
          ),
          decoration: IconDecoration(
            border: IconBorder(
              color: AppColors.yellow,
              width: 2.w,
            ),
          ),
        ),
      ),
      onRatingUpdate: (rating) {
       
      },
    );
  }
}

class ItemRating extends StatelessWidget {
  const ItemRating(
      {super.key, required this.ratingNumber, required this.widthRating});
  final int ratingNumber;
  final double widthRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          ratingNumber.toString(),
          style: AppStyles.interSemiBoldTextButton
              .medium()
              .withSize(FontSizes.title),
        ),
        Gap(4.w),
        Icon(
          Icons.star,
          color: AppColors.yellow,
          size: 16.r,
        ),
        Gap(4.w),
        Container(
          height: 6.h,
          width: widthRating.w,
          decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4)),
        )
      ],
    ).marginOnly(bottom: 4.h);
  }
}
