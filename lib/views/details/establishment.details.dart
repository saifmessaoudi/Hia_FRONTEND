// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/views/offers/offers_establishment.dart';



import 'package:nb_utils/nb_utils.dart' as nb_utils;
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant.dart';

class EstablishmentDetailsScreen extends StatefulWidget {
  const EstablishmentDetailsScreen({required this.establishment});

  final Establishment establishment;

  static const IconData contact_phone = IconData(0xe18c, fontFamily: 'MaterialIcons');

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<EstablishmentDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
            final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);

    return SafeArea(
      child: Scaffold(
                 resizeToAvoidBottomInset: false,

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
                        height: 150,
                      ),
                      
                      Container(
                        width: context.width(),
                        height: context.height()+300,
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
                            
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: IconButton(
                                  icon:const  Icon(Icons.phone_in_talk_sharp, color:  Color.fromARGB(255, 0, 26, 48)),
                                  onPressed: () async {
                                    String phoneNumber = 'tel:${widget.establishment.phone}';
                                    if (await canLaunch(phoneNumber)) {
                                      await launch(phoneNumber);
                                    } else {
                                      throw 'Could not launch $phoneNumber';
                                    }
                                  },
                                ),
                              ),
                              const Gap(20),
                                Text(
                                    widget.establishment.name,
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  const Gap(15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 15),
                                  Text(
                                    widget.establishment.isOpened ? 'Opened' : 'Closed',
                                    style: kTextStyle.copyWith(
                                      color: widget.establishment.isOpened ? kMainColor : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 7),
                                  Icon(
                                    Icons.access_time,
                                    color: widget.establishment.isOpened ? kMainColor : const Color.fromARGB(255, 114, 26, 19),
                                    size: 16,
                                  ),
                                  const Spacer(),
                                  // Add your title and icon here
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, 
                                        MaterialPageRoute(builder: (context) =>  OffersEstablishmentScreen(id:widget.establishment.id)
                                        ));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Browse Offer',
                                            style: kTextStyle.copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 5), // Adjust spacing
                                          Icon(
                                            Icons.shopping_bag,
                                            color: kMainColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),

                                  const SizedBox(width: 15), // Adjust spacing
                                ],
                              ),
                              const Gap(10),

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
    text:const  TextSpan(
      children: [
         WidgetSpan(
          child: Icon(
            Icons.location_on,
            color: kMainColor,
            size: 18.0,
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
        const WidgetSpan(
          child: Icon(
            Icons.star,
            color: Colors.amber,
            size: 18.0,
          ),
        ),
        TextSpan(
          text: widget.establishment.averageRating.toString(), 
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
  child: Padding(
    padding: const EdgeInsets.only(
                                  left: 15.0,
                                  ),
    
  child: RichText(
    text: TextSpan(
      children: [
        const WidgetSpan(
          child: Icon(
            Icons.reviews,
            color: Color.fromARGB(255, 5, 32, 54),
            size: 18.0,
          ),
        ),
        TextSpan(
          text: "${widget.establishment.reviews?.length}  Reviews", 
          style: kTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: kTitleColor,
          ),
        ),
      ],
    ),
  ),
),
),


                                  /*Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              FontAwesomeIcons.clock,
                                              color: kMainColor,
                                              size: 18.0,
                                            ),
                                          ),
                                         /* TextSpan(
                                            text:
                                                '${widget.product.productTime} Min',
                                            style: kTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: kTitleColor,
                                            ),
                                          ),
                                        ],
                                      ),*/
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                           Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ReadMoreText(
                                widget.establishment.description!,
                                trimLines: 10,
                                colorClickableText: kMainColor,
                                trimMode: TrimMode.Line,
                                style: kTextStyle.copyWith(color: kTitleColor),
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                                moreStyle:
                                    kTextStyle.copyWith(color: kMainColor),
                              ),
                            ),
                            const SizedBox(height: 20.0,),
                            
                            
                            Row(
                              children: [
                               /* Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ButtonGlobal(
                                      buttontext: 'Add To Cart',
                                      buttonDecoration:
                                          kButtonDecoration.copyWith(color: kMainColor),
                                      onPressed: (){
                                        ///const CartScreen().launch(context);
                                      },
                                    ),
                                  ),
                                ),*/
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ButtonGlobal(
                                      buttontext: 'Checkout',
                                      buttonDecoration:
                                      kButtonDecoration.copyWith(color: kMainColor),
                                      onPressed: (){
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
    backgroundColor: kMainColor,
    radius: MediaQuery.of(context).size.width / 4,
    child: ClipOval(
      child: FadeInImage.assetNetwork(
        placeholder: 'images/offline_icon.png', // Placeholder image asset
        image: widget.establishment.image!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        fadeInDuration: Duration(milliseconds: 300),
        fadeOutDuration: Duration(milliseconds: 300),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'images/offline_icon.png', // Fallback image in case of error
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
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