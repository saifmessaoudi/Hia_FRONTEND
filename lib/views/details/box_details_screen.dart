// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/views/global_components/button_global.dart';

import 'package:nb_utils/nb_utils.dart';

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
                              color: kTitleColor,
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
                        height: 150,
                      ),
                      Container(
                        width: context.width(),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0)),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 100.0,
                            ),
                            SizedBox(
                              width: 100.0,
                              height: 50.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kMainColor,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity > 1
                                              ? quantity -= 1
                                              : quantity = 1;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Text(
                                        quantity.toString(),
                                        style: kTextStyle.copyWith(
                                            color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity > 0
                                              ? quantity += 1
                                              : quantity = 1;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    widget.box.name,
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                ],
                              ),
                            ),
                             //description with read more 
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 10.0),
                              child: Text(
                                widget.box.description,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor, fontSize: 16.0),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 20.0,
                                  top: 10.0),
                              child: Row(
                                children: [
                                 
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                           WidgetSpan(
                                            child: Icon(
                                              Icons.lock_clock,
                                              color: widget.box.isAvailable ? kMainColor : Colors.red,
                                              size: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: widget.box.isAvailable ?  'Available' : 'Not Available',
                                            style: kTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kTitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //quantity
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.shopping_cart,
                                              color: kMainColor,
                                              size: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ${widget.box.quantity} in stock',
                                            style: kTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kTitleColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                 
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ButtonGlobal(
                                      buttontext: 'Add To Cart',
                                      buttonDecoration: kButtonDecoration
                                          .copyWith(color: kMainColor),
                                      onPressed: () {
                                      },
                                    ),
                                  ),
                                ),
                              
                              ],
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
                      child: Image.asset("images/box.png",width: 100.0, height: 100.0,fit: BoxFit.cover,),
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
