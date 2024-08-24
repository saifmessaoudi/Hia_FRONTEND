
import "package:hia/views/home/exports/export_homescreen.dart";

class OffersSection extends StatelessWidget {
  const OffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            children: [
              Text(
                'Available Offers',
                style: kTextStyle.copyWith(
                  color: kTitleColor,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
          Padding(
                padding: const EdgeInsets.all(10.0),
                child: Consumer<OfferViewModel>(
                  builder: (context, offerViewModel, child) {
                    return offerViewModel.isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: SizedBox(
                              height: 245, 
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
                            itemCount: offerViewModel.offers.length,
                            itemBuilder: (_, i) {
                              return SurpriseBoxCard(
                                offer: offerViewModel.offers[i],
                              ).onTap(
                                () {
                                  Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) =>  BoxDetailsScreen(box: offerViewModel.offers[i],),
                                         ),
                                       );
                                },
                                highlightColor: context.cardColor,
                              );
                            },
                          );
                  },
                  
                ),
              ),
              const Gap(10),
      ],
    );
  }
}

 