import 'package:hia/views/home/exports/export_homescreen.dart';

class FoodScreenFavourites extends StatefulWidget {
  const FoodScreenFavourites({super.key});

  @override
  _FoodScreenFavouriteState createState() => _FoodScreenFavouriteState();
}

class _FoodScreenFavouriteState extends State<FoodScreenFavourites> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.getFavouriteFood(userViewModel.userData!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartScaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/hiaauthbgg.png"),
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
                      padding: const EdgeInsets.all(30),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ).onTap(() {
                        Navigator.pop(context);
                      }),
                    ),
                    Text(
                      'Favourite Deals',
                      style: kTextStyle.copyWith(
                          color: Colors.white, fontSize: 18.0),
                    ),
                    const SizedBox(
                      width: 130,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  width: context.width(),
                  height: context.height(),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Consumer<UserViewModel>(
                        builder: (context, userviewmodel, child) {
                          return GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 0.75,
                            crossAxisCount: 2,
                            children: List.generate(
                              userviewmodel.favouritefood!.length,
                              (index) => Center(
                                child: FoodCard(
                                  food: userviewmodel.favouritefood![index],
                                ).onTap(() {
                                  // Handle tap
                                }),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
