import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:shimmer/shimmer.dart';

class CartItemWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double price;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: kGreyTextColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
             ClipOval(
                  child: CachedNetworkImage(
                    width: 70.0,
                    height: 70.0,
                    imageUrl: imageUrl,
                    fit: BoxFit.cover, // Ensure the image covers the circle
                    placeholder: (context, url) => Shimmer(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey, Colors.white],
                      ),
                      child: Container(
                        width: 70.0, // Match the width and height of the image
                        height: 70.0,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
            
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: kTextStyle.copyWith(color: kTitleColor ,fontSize: 16),
                ),
                Text(
                  '\$$price',
                  style: kTextStyle.copyWith(color: kMainColor),
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                GestureDetector(
                  onTap: onDecrease,
                  child: const Icon(
                    Icons.remove,
                    color: kTitleColor,
                  ),
                ),
                Text(
                  quantity.toString(),
                  style: kTextStyle.copyWith(color: kTitleColor),
                ),
                GestureDetector(
                  onTap: onIncrease,
                  child: const Icon(
                    Icons.add,
                    color: kTitleColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
