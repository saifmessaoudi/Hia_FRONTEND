import 'package:flutter/material.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/views/home/BookTableCard.dart';
import 'package:hia/views/home/establishment_details.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import 'home_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  @override
  Widget build(BuildContext context) {
        final establishmentViewModel = Provider.of<EstablishmentViewModel>(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/hiaauthbg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
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
                      Text(
                        'Popular Deals',
                        style: kTextStyle.copyWith(
                            color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    width: context.width(),
                    height: context.height()+500,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.85,
                          crossAxisCount: 2,
                          children: List.generate(
                            establishmentViewModel.establishments!.length,
                            (index) => Center(
                              child: BookTableCard(
                                restaurantData: establishmentViewModel.establishments![index],
                                index: index,
                              ).onTap(() {
                                ProductDetails(product: establishmentViewModel.establishments![index],index : index)
                                    .launch(context);
                              }),
                            ),
                          ),
                        ),
                      ],
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
