import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hia/constant.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    Key? key,
    //  required this.productData
  }) : super(key: key);
  //final ProductData productData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 160.0,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image(
                     // image: AssetImage(productData.productImage),
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),*/
                  /*  Row(
                    children: [
                      Text(
                      //  productData.productTitle,
                       // style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                    ],
                  ),*/
                  Row(
                    children: [
                      RatingBarIndicator(
                        //  rating: productData.productRating.toDouble(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star_border,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 10.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      /*  Text(
                     //   productData.productRating,
                      //  style: kTextStyle.copyWith(color: kGreyTextColor),
                      ),*/
                    ],
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: Icon(
                                  Icons.attach_money,
                                  color: kMainColor,
                                  size: 7.0,
                                ),
                              ),
                            ),
                            TextSpan(
                              // text: productData.productPrice,
                              style: kTextStyle.copyWith(
                                  color: kTitleColor, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        backgroundColor: kSecondaryColor,
                        radius: 16.0,
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          color: kMainColor,
                          size: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE51000).withOpacity(0.1),
            radius: 16.0,
            child: const Icon(
              Icons.favorite,
              color: Color(0xFFE51000),
              size: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}