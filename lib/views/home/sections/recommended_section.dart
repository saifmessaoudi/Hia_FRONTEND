
import "package:hia/views/home/exports/export_homescreen.dart";

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Recommended for you',
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
                      //const ProductScreen().launch(context);
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<EstablishmentViewModel>(
                  builder: (context, establishmentViewModel, child) {
                    if(establishmentViewModel.recommendedEstablishments.isEmpty) {
                      const Gap(20.0);
                      return const Center(

                        child: Text(
                          'Oops! No recommended establishments',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      
                      ); 
                    } 
                    else {
                     return establishmentViewModel.isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SizedBox(
                              height: 170, // Specify a fixed height for the ListView
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (_, __) => Container(
                                  width: 300,
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
                            itemCount: establishmentViewModel.recommendedEstablishments.length,
                            itemBuilder: (_, i) {
                              return EstablishmentCard(establishment: establishmentViewModel.recommendedEstablishments[i]).onTap(
                                () {
                                 //navigate 
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  EstablishmentDetailsScreen(establishment: establishmentViewModel.recommendedEstablishments[i],),
                                      ),
                                    );
                                },
                                highlightColor: context.cardColor,

                              );
                            }
                          );
                    }
                  },
                ),
              ), 
        ],
    );
  }
}

