import 'package:flutter/material.dart';
import 'package:hia/app/style/widget_modifier.dart';
import 'package:hia/constant.dart';
import 'package:hia/viewmodels/market_viewmodel.dart';
import 'package:hia/views/markets/MarketCardGrid.dart';
import 'package:hia/views/markets/market_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MarketGrid extends StatelessWidget {
  const MarketGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketViewModel>(
      builder: (context, marketViewModel, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
              Expanded(
                child: marketViewModel.isLoading || marketViewModel.isSorting
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: kMainColor,
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.75,
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 2.0,
                          children: List.generate(
                            4,
                            (index) => Container(
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    : marketViewModel.markets.isEmpty
                        ? const Center(
                            child: Text(
                              'There is no available data',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.75,
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 2.0,
                            children: List.generate(
                              marketViewModel.markets.length,
                              (index) => Center(
                                child: Marketcardgrid(
                                  restaurantData:
                                      marketViewModel.markets[index],
                                  index: index,
                                  isGrid: true,
                                ).onTap(() async {
                                  await marketViewModel
                                      .fetchMarketsByName(
                                          marketViewModel
                                              .markets[index].name);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MarketDetailScreen(
                                        box: marketViewModel
                                            .markets[index],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}
