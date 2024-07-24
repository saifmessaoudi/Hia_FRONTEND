import 'package:hia/views/home/exports/export_homescreen.dart';

class NearlySection extends StatelessWidget {
  const NearlySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Nearly Establishments',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontSize: 18.0,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'See all',
                      style: kTextStyle.copyWith(color: kGreyTextColor),
                    ).onTap(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductScreen(),
                        ),
                      );
                    }),
                  ],
                ),
              ),
        
              Consumer<EstablishmentViewModel>(
                builder: (context, establishmentViewModel, child) {
                  if (establishmentViewModel.isLoading ||
                      establishmentViewModel.isSorting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kMainColor,
                      ),
                    );
                  }
        
                  if (establishmentViewModel.establishments.isNotEmpty) {
                    return HorizontalList(
                      spacing: 10,
                      itemCount: establishmentViewModel.establishments.length,
                      itemBuilder: (_, i) {
                        return BookTableCard(
                          restaurantData:
                              establishmentViewModel.establishments[i],
                          index: i,
                        ).onTap(
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EstablishmentDetailsScreen(
                                  establishment:
                                      establishmentViewModel.establishments[i],
                                ),
                              ),
                            );
                          },
                          highlightColor: context.cardColor,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: Text(
                      'There is no available data',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}