import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:hia/app/style/widget_modifier.dart';


class ProfileBottomSheet extends StatelessWidget {
  const ProfileBottomSheet({
    super.key,
    this.imageExist = true,
  });


  final bool imageExist;

  @override
  Widget build(BuildContext context) {
    
        return SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Add profile picture",
                        style: AppStyles.interSemiBoldTextButton.withColor(Colors.white).withSize(FontSizes.headline5),
                      ).align(alignment: Alignment.topLeft),
                      Gap(26.h),
                      InkWell(
                        onTap: (){},
                        child: Row(
                          children: [
                            Image.asset(
                              "images/editpicicon.png",
                              width: 25.r,
                              height: 25.r,
                             
                            ),
                            Gap(10.w),
                            Text(
                              "Take a photo",
                              style: AppStyles.interSemiBoldTextButton.medium().withColor(Colors.white).withSize(FontSizes.title),
                            ),
                          ],
                        ),                     
                         ),
                       Gap(10.h),
                      InkWell(
                        onTap: (){},
                        child: Row(
                          children: [
                            Image.asset(
                              "images/editpicicon.png",
                              height: 25.r,
                              width: 25.r,
                            ),
                            Gap(10.w),
                            Text(
                              "Upload from phone",
                              style: AppStyles.interSemiBoldTextButton.medium().withColor(Colors.white).withSize(FontSizes.title),
                            ),
                          ],
                        ),
                      ),
                       Gap(10.h),
                    ],
                  ),
                ).customPadding(
                    right: 24.w,
                    left: 24.w,
                    top: 60.h,
                    bottom: 10.h,);
  }
}
