import 'package:flutter/material.dart';
import 'package:hia/constant.dart';

class CartItemWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int price;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemWidget({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

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
            CircleAvatar(
              radius: 40.0,
              backgroundColor: kMainColor,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: kTextStyle.copyWith(color: kTitleColor),
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
