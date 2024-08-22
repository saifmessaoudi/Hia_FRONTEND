// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/views/global_components/button_global.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/views/offers/offers_establishment.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils;
import 'package:url_launcher/url_launcher_string.dart';

class EstablishmentDetailsScreen extends StatefulWidget {
  const EstablishmentDetailsScreen({required this.establishment});

  final Establishment establishment;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<EstablishmentDetailsScreen> {
          
  

  @override
  Widget build(BuildContext context) {  
    final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: true);
    //get index establishment 
    int index = establishmentViewModel.establishments.indexWhere((element) => element.id == widget.establishment.id);
    return SmartScaffold(
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
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
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      Container(
                        width: context.width(),
                        height: context.height() + 300,
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
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: IconButton(
                                icon: const Icon(Icons.phone_in_talk_sharp,
                                    color: Color.fromARGB(255, 0, 26, 48)),
                                onPressed: () async {
                                  final phoneNumber =
                                      'tel:${widget.establishment.phone}';
                                  if (await canLaunchUrlString( phoneNumber)) {
                                    await launchUrlString(phoneNumber);
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
                                  widget.establishment.isOpened
                                      ? 'Opened'
                                      : 'Closed',
                                  style: kTextStyle.copyWith(
                                    color: widget.establishment.isOpened
                                        ? kMainColor
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Icon(
                                  Icons.access_time,
                                  color: widget.establishment.isOpened
                                      ? kMainColor
                                      : const Color.fromARGB(255, 114, 26, 19),
                                  size: 16,
                                ),
                                const Spacer(),
                                // Add your title and icon here
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OffersEstablishmentScreen(
                                                    id: widget
                                                        .establishment.id)));
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
                                      const SizedBox(width: 5), // Adjust spacing
                                      const Icon(
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
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.location_on,
                                              color: kMainColor,
                                              size: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${establishmentViewModel.distances[index].toStringAsFixed(1)} km",
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
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 18.0,
                                            ),
                                          ),
                                          TextSpan(
                                            text: widget
                                                .establishment.averageRating
                                                .toString(),
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
                                      child: GestureDetector(
                                        onTap: () {
                                          
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.reviews,
                                                  color: Color.fromARGB(
                                                      255, 5, 32, 54),
                                                  size: 18.0,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "${widget.establishment.reviews?.length}  Reviews",
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
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),

                            //Our products with see all row
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Our Products',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => ProductListScreen(),
                                          //   ),
                                          // );
                                        },
                                        child: Text(
                                          'See all',
                                          style: kTextStyle.copyWith(
                                              color: kMainColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                //Product list
                                //ProductList(),
                              ],
                            ),

                            // list builder food card
                            HorizontalList(
                              spacing: 10,
                              itemCount:
                                  widget.establishment.foods?.length ?? 0,
                              itemBuilder: (_, i) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FoodDetailsScreen(
                                            food:
                                                widget.establishment.foods![i]),
                                      ),
                                    );
                                  },
                                  child: FoodCard(
                                      food: widget.establishment.foods![i]),
                                );
                              },
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ButtonGlobal(
                                      buttonTextColor: Colors.white,
                                      buttontext: 'Checkout',
                                      buttonDecoration: kButtonDecoration
                                          .copyWith(color: kMainColor),
                                      onPressed: () {},
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
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          child: CachedNetworkImage(
                            imageUrl: widget.establishment.image!,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
