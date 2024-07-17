import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/offer.model.dart';

class SurpriseBoxCard extends StatelessWidget {
  const SurpriseBoxCard({super.key, required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Container(
        width: 300.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/boxfood.jpg",
                width: 80.0,
                height: 80.0,
              ),
              
              const Gap(10),
              Text(
                offer.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kTitleColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(10),
              
                 Text(
                    " ${offer.quantity} items left",
                    style:  TextStyle(
                      fontSize: 14,
                      color: offer.quantity < 5 ? Colors.red : kTitleColor,
                    ),
                  ),
                
             
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.access_time, color:  offer.validUntil.difference(DateTime.now()).inDays < 3
                          ? Colors.red
                          : kTitleColor),
                  const SizedBox(width: 5),

                  Text(
                    "Expires in ${offer.validUntil.difference(DateTime.now()).inDays} days",
                    style:  TextStyle(
                      fontSize: 14,
                      color: offer.validUntil.difference(DateTime.now()).inDays < 3
                          ? Colors.red
                          : kTitleColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
