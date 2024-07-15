import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hia/models/offer.model.dart';

class SurpriseBoxCard extends StatelessWidget {
  const SurpriseBoxCard({super.key , required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
    
        children: <Widget>[
          const Gap(10),
          Image.asset(
            "images/box.png",
            width: 60.0,
            height: 60.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              offer.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Available until : ${offer.formattedValidUntil}",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}