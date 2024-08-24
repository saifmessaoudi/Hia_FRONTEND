import "package:hia/views/home/exports/export_homescreen.dart";

class PopularDealsSection extends StatelessWidget {
  const PopularDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [
              Text(
                'Popular Deals',
                style: kTextStyle.copyWith(
                  color: kTitleColor,
                  fontSize: 18.0,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FoodScreen(),
                    ),
                  );
                },
                child: Text(
                  'See all',
                  style: kTextStyle.copyWith(color: kGreyTextColor),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Consumer<FoodViewModel>(
            builder: (context, foodViewModel, child) {
              if (foodViewModel.isLoading && foodViewModel.foods.isEmpty) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: SizedBox(
                    height: 150, // Specify a fixed height for the ListView
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (_, __) => Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (foodViewModel.foods.isEmpty) {
                return Center(
                  child: SizedBox(
                    height: 80,
                    child: Text(
                      'No deals for now',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ),
                  ),
                );
              } else {
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!foodViewModel.isLoading &&
                        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      foodViewModel.fetchFoods();
                      return true;
                    }
                    return false;
                  },
                  child: HorizontalList(
                    spacing: 10,
                    itemCount: foodViewModel.foods.length + (foodViewModel.isLoading ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == foodViewModel.foods.length) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 200,
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodDetailsScreen(food: foodViewModel.foods[i]),
                            ),
                          );
                        },
                        child: FoodCard(food: foodViewModel.foods[i]),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}