


import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:nb_utils/nb_utils.dart';


class BookTableCard extends StatelessWidget {
  final Establishment establishment;
 

     BookTableCard({required this.establishment});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0,bottom: 10.0),
      child: Material(
        color: Colors.white,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Padding(
        
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 280.0,
            child: Column(
              children: [
                const Padding(
                  padding:  EdgeInsets.only(top: 8.0),
                  child: Image(image: AssetImage("images/restaurant.png"),fit: BoxFit.cover,),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(establishment.name, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),),
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
                                  text: establishment.address,
                                  style: kTextStyle.copyWith(
                                      color: kGreyTextColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: establishment.averageRating.toString(),
                                  style: kTextStyle.copyWith(
                                      color: kGreyTextColor),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(width: 2.0,),
                                ),
                                
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.star_rate_rounded,
                                    color: kMainColor,
                                    size: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                establishment.isOpened ? 
                                TextSpan(
                                  text: "Open",
                                  style: kTextStyle.copyWith(
                                      color: kMainColor),
                                ) :
                                TextSpan(
                                  text: "Closed",
                                  style: kTextStyle.copyWith(
                                      color: Colors.red),
                                ),
                                const WidgetSpan(
                                  child: SizedBox(width: 2.0,),
                                ),
                              ],
                            ),
                          ),
                        ),
                         ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

