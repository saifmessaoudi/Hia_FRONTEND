import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class BookTableCardGrid extends StatelessWidget {
  const BookTableCardGrid({
    Key? key,
    required this.restaurantData,
    required this.index,
  }) : super(key: key);

  final Establishment restaurantData;
 final  int index ; 

  @override
  Widget build(BuildContext context) {
        final establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            
            width: 250.0,
            height: 250.0,
            child :Column(
  children: [
    Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Image.network(
          restaurantData.image ?? '',
          fit: BoxFit.cover,
          height: 130,
          width: 130,
        ),
      ),
    ),
    const SizedBox(height: 10,),
    Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantData.name.toUpperCase(),
                  style: kTextStyle.copyWith(
                    color: kTitleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10,),
                 RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: SizedBox(width: 5.0),
                      ),
                      TextSpan(
                        text: restaurantData.averageRating.toString(),
                        style: kTextStyle.copyWith(
                          color: kTitleColor,
                        ),
                      ),
                      const WidgetSpan(
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.location_on,
                          color: kMainColor,
                          size: 15.0,
                        ),
                      ),
                      TextSpan(
                        text: "${establishmentViewModel.distances![index].toStringAsFixed(1)} km",
                        style: kTextStyle.copyWith(
                          color: kGreyTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
               
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 60.0, ),
                child :Row(
      children: [
        Icon(
          Icons.access_time,
          color: restaurantData.isOpened ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 5),
       
      ],
    ),
    ),
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, bottom: 4.0,),
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Image.asset(
                    'images/maps.png',
                    width: 40,
                    height: 40,
                  ),
                ).onTap(() {
                  establishmentViewModel.launchMaps(restaurantData.latitude, restaurantData.longitude);
                }),
              ),
              
            ],
            
          ),
        ),
      ],
    ),
  ],
),

          ),
        ),
      ),
    );
  }
}