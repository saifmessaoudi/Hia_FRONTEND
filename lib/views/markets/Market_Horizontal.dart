import 'package:flutter/material.dart';
import 'package:hia/app/style/widget_modifier.dart';
import 'package:hia/constant.dart';
import 'package:hia/viewmodels/market_viewmodel.dart';
import 'package:hia/views/markets/MarketCardGrid.dart';
import 'package:hia/views/markets/market_detail_screen.dart';
import 'package:shimmer/shimmer.dart';

class MarketHorizontal extends StatelessWidget {
  final MarketViewModel marketViewModel;
  
  const MarketHorizontal({
    super.key,
    required this.marketViewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (marketViewModel.marketsByName.isEmpty) {
      return const Center(
        child: Text(
          'There is no available data',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 300,  // Adjust height for horizontal list
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            marketViewModel.isFiltering
                ? Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: kMainColor,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,  // Placeholder items for loading
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 150,  // Adjust width for horizontal list
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,  // Set the direction to horizontal
                      itemCount: marketViewModel.marketsByName.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Marketcardgrid(
                            restaurantData: marketViewModel.marketsByName[index],
                            index: index,
                            isGrid: false,  // It's now horizontal, not grid
                          ).onTap(() async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MarketDetailScreen(
                                  box: marketViewModel.marketsByName[index],
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );
    }
  }
}
