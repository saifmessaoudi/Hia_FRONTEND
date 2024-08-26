import 'package:hia/app/style/app_style.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Scaffold(
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
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Image.asset('images/left-arrow.png',
                          width: 18.w, height: 18.w),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      'Your Favourites',
                      style: AppStyles.interboldHeadline5
                          .medium()
                          .withColor(Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: context.width(),
                        height: context.height() - 50,
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
                                if (userviewmodel.isLoading) {
                                  return CustomScrollView(
                                    shrinkWrap: true,
                                    slivers: [
                                      SliverGrid(
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        mainAxisSpacing:  10.0, ),
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 90,
                                                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: 1, 
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return CustomScrollView(
                                    shrinkWrap: true,
                                    slivers: [
                                      SliverGrid(
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.9,
                                        ),
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            return Center(
                                              child: FoodCard(
                                                food: userviewmodel.favouritefood![index],
                                              ).onTap(() {
                                                // Handle tap
                                              }),
                                            );
                                          },
                                          childCount: userviewmodel.favouritefood!.length,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}