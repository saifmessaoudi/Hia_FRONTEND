import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/widgets/custom_toast.dart';


class FoodCard extends StatefulWidget {
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
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.verifFoodFavourite(widget.food.id, userViewModel.userData!.id);
  }
  

  @override
  Widget build(BuildContext context) {
    final cartViewModel = Provider.of<CartViewModel>(context);
    return Stack(
      children: [
        SizedBox(
          width: 160.0,
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
                    SizedBox(
                      width: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            width: 160.0,
                            height: 110.0,
                            imageUrl: widget.food.image,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.grey, Colors.white],
                              ),
                              child: Container(
                                width: 100.0,
                                height: 100.0,
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset('images/placeholder.png' , width: 100.0, height: 100.0),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.food.name,
                            style: kTextStyle.copyWith(color: kTitleColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
                                  child: Text(
                                    'TND',
                                    style: TextStyle(
                                      color: kGreyTextColor,
                                      fontSize: 5.0,
                                    )
                                    
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
                        GestureDetector(
                          onTap: () {
                            cartViewModel
                                .addItem(widget.food, 1)
                                .then((success) {
                              if (success) {
                                showCustomToast(context, "Item added to cart");
                              } else {
                                showCustomToast(context,
                                    "You cannot add items from different restaurants to the cart",
                                    isError: true);
                              }
                            });
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 16.0,
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: kMainColor,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
                    await userViewModel.removeFoodsFromFavourites(
                        widget.food.id, userViewModel.userData!.id);
                  } else {
                    await userViewModel.addFoodsToFavourites(
                        widget.food.id, userViewModel.userData!.id);
                  }
                  await userViewModel.verifFoodFavourite(
                      widget.food.id, userViewModel.userData!.id);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 13.0,
                  child: Icon(
                    Icons.favorite_rounded,
                    color: isFavourite ? Colors.red : Colors.grey,
                    size: 22.0,
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }  
  
}

