import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class FoodCard extends StatefulWidget  {
  final Food food;

  const FoodCard({
    super.key,
    required this.food,
  });
   @override
  _FoodCardState createState() => _FoodCardState();

}

class _FoodCardState extends State<FoodCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      await userViewModel.verifFoodFavourite(widget.food.id, userViewModel.userData!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 160.0,
          child: Card(
            elevation: 5.0, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: kMainColor.withOpacity(0.5), 
                width: 2.0, 
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white, // Shadow color
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image(
                        image: NetworkImage(widget.food.image ?? ''),
                        width: 100.0,
                        height: 100.0,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.food.name,
                          style: kTextStyle.copyWith(color: kTitleColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: widget.food.averageRating.toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 10.0,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          widget.food.averageRating.toString(),
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 12.0),
                                  child: Icon(
                                    Icons.attach_money,
                                    color: kMainColor,
                                    size: 7.0,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: widget.food.price.toString(),
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 16.0,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: kMainColor,
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
       Consumer<UserViewModel>(
  builder: (context, userViewModel, child) {
    final isFavourite = userViewModel.getFavouriteStatus(widget.food.id);
    
    return Positioned(
      top: 10.0,
      right: 10.0,
      child: GestureDetector(
        onTap: () async {
          if (isFavourite) {
            await userViewModel.removeFoodsFromFavourites(widget.food.id, userViewModel.userData!.id);
          } else {
            await userViewModel.addFoodsToFavourites(widget.food.id, userViewModel.userData!.id);
          }
        },
        child: CircleAvatar(
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  radius: 12.0,
                                  child: Icon(
                                    Icons.favorite_rounded,
                                    color: isFavourite ? Colors.red : Colors.grey,
                                    size: 18.0,
                                  ),
                                ),
      ),
    );
  }
)

      ],
    );
  }
}
