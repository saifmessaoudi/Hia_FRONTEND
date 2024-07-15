import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:hia/views/global_components/category_data.dart';

class CatCard extends StatelessWidget {
  const CatCard({Key? key, required this.catList}) : super(key: key);
  final CategoryData catList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image(
                image: AssetImage(catList.catIcon),
              ),
            )),
        Text(
          catList.catTitle,
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
      ],
    );
  }
}