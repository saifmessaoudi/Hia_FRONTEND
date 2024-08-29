import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';

class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [
              Text(
                'Available Offers',
                style: kTextStyle.copyWith(
                  color: kTitleColor,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<OfferViewModel>(
            builder: (context, offerViewModel, child) {
              return offerViewModel.isLoading
                  ? HorizontalList(
                      spacing: 10,
                      itemCount: 3,
                      itemBuilder: (_, i) {
                        return _buildLoadingCard();
                      },
                    )
                  : HorizontalList(
                      spacing: 10,
                      itemCount: offerViewModel.offers.length,
                      itemBuilder: (_, i) {
                        return SurpriseBoxCard(
                          offer: offerViewModel.offers[i],
                        ).onTap(
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoxDetailsScreen(
                                  box: offerViewModel.offers[i],
                                ),
                              ),
                            );
                          },
                          highlightColor: context.cardColor,
                        );
                      },
                    );
            },
          ),
        ),
        const Gap(10),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return SizedBox(
      width: 280.w,
      height: 248.h,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              child: Container(
                width: double.infinity,
                height: 150.h,
                color: Colors.grey[300],
              ),
            ),
            const Gap(8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 24.w,
                          height: 24.h,
                          color: Colors.grey[300],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 100.w,
                        height: 15.h,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  const Gap(6),
                  Container(
                    width: 150.w,
                    height: 13.h,
                    color: Colors.grey[300],
                  ),
                  const Gap(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.grey[300],
                            size: 16,
                          ),
                          const Gap(4),
                          Container(
                            width: 80.w,
                            height: 13.h,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                      Container(
                        width: 50.w,
                        height: 15.h,
                        color: Colors.grey[300],
                      ),
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