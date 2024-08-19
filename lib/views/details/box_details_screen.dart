import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/views/details/establishment.details.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../constant.dart';

class BoxDetailsScreen extends StatefulWidget {
  const BoxDetailsScreen({required this.box});

  final Offer box;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<BoxDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/hiaauthbgg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ).onTap(() {
                              Navigator.pop(context);
                            }),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            radius: 16.0,
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.red,
                              size: 16.0,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 220,
                      ),
                      Container(
                        width: context.width(),
                        height: context.height() - 200,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 100.0,
                              child: Center(
                                child: Text(
                                  widget.box.name,
                                  style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EstablishmentDetailsScreen(
                                                  establishment: widget
                                                      .box.etablishment)));
                                },
                                child: Text(
                                  widget.box.etablishment.name,
                                  style: kTextStyle.copyWith(
                                    color: kMainColor,
                                    fontSize: 17.0,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.lock_clock,
                                              color: widget.box.isAvailable
                                                  ? kMainColor
                                                  : Colors.red,
                                              size: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: widget.box.isAvailable
                                                ? ' Available'
                                                : ' Not Available',
                                            style: kTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kTitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.shopping_cart,
                                              color: widget.box.quantity < 3
                                                  ? Colors.red
                                                  : kMainColor,
                                              size: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                " ${widget.box.quantity} items left",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: widget.box.quantity < 3
                                                  ? Colors.red
                                                  : kTitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                widget.box.description,
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontSize: 16.0,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            //price tunisian
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Price: ',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Text(
                                    '${widget.box.price} TND',
                                    style: kTextStyle.copyWith(
                                      color: kMainColor,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ButtonGlobal(
                                      buttonTextColor: Colors.white,
                                      buttontext: 'Add To Cart',
                                      buttonDecoration: kButtonDecoration
                                          .copyWith(color: kMainColor),
                                      onPressed: () {
                                        // Implement add to cart logic
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 60.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: MediaQuery.of(context).size.width / 4,
                      child: ClipOval(
                        child: FastCachedImage(
                          url: widget.box.image,
                          width: MediaQuery.of(context).size.width / 2, 
                          height: MediaQuery.of(context).size.width / 2, 
                          fit: BoxFit.cover, 
                          loadingBuilder: (context, loadingProgress) {
                            return loadingProgress.isDownloading && loadingProgress.totalBytes != null
                                ? Shimmer(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      height: MediaQuery.of(context).size.width / 2,
                                      color: AppColors.unselectedItemShadow,
                                    ),
                                  )
                                :  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2,
                                    height: MediaQuery.of(context).size.width / 2,
                                  );
                          },
                        ),
                      ),
                    ),
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
