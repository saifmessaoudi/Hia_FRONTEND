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
              return foodViewModel.isLoading
                  ? Shimmer.fromColors(
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
                    )
                  : HorizontalList(
                      spacing: 10,
                      itemCount: foodViewModel.foods.length,
                      itemBuilder: (_, i) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodDetailsScreen(food: foodViewModel.foods[i]),
                              ),
                            );
                          },
                          child: FoodCard(food: foodViewModel.foods[i]),
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}