import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:get/get.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:hia/models/market.model.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/viewmodels/food_viewmodel.dart';
import 'package:hia/viewmodels/market_viewmodel.dart';
import 'package:hia/viewmodels/product_viewmodel.dart';
import 'package:hia/views/details/establishment.details.dart';
import 'package:hia/views/details/food_details_screen.dart';
import 'package:hia/views/markets/MarketCardGrid.dart';
import 'package:hia/views/markets/Market_Horizontal.dart';
import 'package:hia/views/markets/marget_grid_list.dart';
import 'package:hia/views/markets/product_card.dart';
import 'package:hia/views/markets/product_detail_screen.dart';
import 'package:hia/views/markets/products_grid_list.dart';
import 'package:hia/views/markets/products_list.dart';
import 'package:hia/widgets/homescreen/food_card.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant.dart';

class MarketDetailScreen extends StatefulWidget {
  const MarketDetailScreen({super.key, required this.box});

  final Market box;

  @override
  _MarketDetailScreenState createState() => _MarketDetailScreenState();
}

class _MarketDetailScreenState extends State<MarketDetailScreen> {
  //int quantity = 1;

  @override
  Widget build(BuildContext context) {
        final marketViewModel = Provider.of<MarketViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 250.0,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
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
            flexibleSpace: FlexibleSpaceBar(
              background: ClipPath(
                clipper: CustomShapeClipper(),
                child: Stack(
                  children: [
                    FastCachedImage(
                      url: widget.box.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300.0,
                      loadingBuilder: (context, loadingProgress) {
                        return loadingProgress.isDownloading &&
                                loadingProgress.totalBytes != null
                            ? Shimmer(
                               gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                                child: Container(
                                  width: double.infinity,
                                  height: 350.0,
                                  color: AppColors.unselectedItemShadow,
                                ),
                              )
                            : const SizedBox(
                                width: double.infinity,
                                height: 300.0,
                              );
                      },
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  Container(
  alignment: Alignment.bottomCenter,  // Can be topCenter, bottomLeft, etc.
  margin: const EdgeInsets.all(25.0),
  child: Text(
    widget.box.name,
    style: AppStyles.interSemiBoldTextButton
      .black()
      .withSize(FontSizes.headline2)
      .withColor(AppColors.offWhite),
    textAlign: TextAlign.start
  ),
),

                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 // const QuantityControl(),
                  const Gap(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      const SizedBox(width: 20),
                      StatusChip(
                        status: widget.box.isOpened
                            ? 'Available'
                            : 'Not Available',
                        icon: Icons.lock_clock,
                        textColor: widget.box.isOpened
                            ? AppColors.background
                            : Colors.red,
                        iconColor: widget.box.isOpened
                            ? AppColors.background
                            : Colors.red,
                        backgroundColor: widget.box.isOpened
                            ? AppColors.background.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                      ),
                      const SizedBox(width: 10),
                   
                    ],
                  ),
                  const Gap(40),
                   Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                   Text(
  'Our Products: ${widget.box.categories!.length+1}',
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductsGridList(box: widget.box),
            ),
          );
                   }),
                  ],
                ),
              ),
                                
SizedBox(
  height: MediaQuery.of(context).size.height * 0.25, // Adjust height for one line
  child: widget.box.products != null && widget.box.products!.isNotEmpty
      ? ListView.builder(
          scrollDirection: Axis.horizontal, // Horizontal scrolling
          itemCount: widget.box.products!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
               /* showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.box.products![index].name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('Price: \$${widget.box.products![index].price}'),
                          const SizedBox(height: 10),
                          Text(widget.box.products![index].description ?? 'No description available'),
                        ],
                      ),
                    );
                  },
                );*/
                 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailScreen(
                                        product : widget.box.products![index],
                                      ),
                                    ),
                                  );
              },
              child: SizedBox(
                width: 150, // Adjust width for each item
                child: ProductCard(
                  product: widget.box.products![index],
                ),
              ),
            );
          },
        )
      : const Center(
          child: Text(
            'No available data',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
),
Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Others :',
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
         /* Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FoodSeeAllScreenEstablishment(product: widget.product),
            ),
          );*/
                   }),
                  ],
                ),
              ),
                                
SizedBox(
  height: MediaQuery.of(context).size.height * 0.25, // Adjust height for one line
  child: marketViewModel.markets.isNotEmpty
      ? ListView.builder(
          scrollDirection: Axis.horizontal, // Horizontal scrolling
          itemCount: marketViewModel.markets.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                /*showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.box.products![index].name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('Price: \$${widget.box.products![index].price}'),
                          const SizedBox(height: 10),
                          Text(widget.box.products![index].description ?? 'No description available'),
                        ],
                      ),
                    );
                  },
                );*/
              },
              child: SizedBox(
                // Adjust width for each item
                child: Marketcardgrid(
                                  restaurantData:
                                      marketViewModel.markets[index],
                                  index: index,
                                  isGrid: true,
                                )
              ),
            );
          },
        )
      : const Center(
          child: Text(
            'No available data',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
),


const SizedBox(height: 60),
                  Padding(
  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0), // Increase external padding if needed
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 70.0), // Increase internal padding
    decoration: BoxDecoration(
      color: kMainColor,
      borderRadius: BorderRadius.circular(25.0), // Adjust radius for larger button aesthetics
    ),
    child: Text(
      'Checkout',
      style: kTextStyle.copyWith(
        fontSize: 18, // Increase font size
        color: Colors.white,
        fontWeight: FontWeight.bold, // Make text more prominent
      ),
    ),
  ).onTap(() {
    marketViewModel.launchMaps(
        widget.box.latitude, widget.box.langitude);
  }),
),


  const SizedBox(height: 80,),
                  /*Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Others ${widget.box.name} :',
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
         /* Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FoodSeeAllScreenEstablishment(product: widget.product),
            ),
          );*/
                   }),
                  ],
                ),
                
              ),*/
              /* Consumer<MarketViewModel>(
    builder: (context, marketViewModel, child) {
      return MarketHorizontal(marketViewModel : marketViewModel);
    },
  ),*/
 // SizedBox(height: 20,),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.box.price} TND',
                        style: AppStyles.interSemiBoldTextButton
                            .bold()
                            .withSize(FontSizes.headline4).withColor(AppColors.offBlack),
                      ),
                    ],
                  ),*/
                  const Gap(20),
                 /* Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Handle order action
                            final cartViewModel = Provider.of<CartViewModel>(
                              context,
                              listen: false,
                            );
                            bool success = await cartViewModel.addItem(
                              null,
                              quantity,
                             // offer:widget.box,
                            );
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Item added to cart'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to add item to cart'),
                                ),
                              );
                            }

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(vertical: 11.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                          ),
                          child: Text(
                            'Add to cart',
                            style: AppStyles.interSemiBoldTextButton
                                .withColor(AppColors.offWhite)
                                .withSize(FontSizes.headline5),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class StatusChip extends StatelessWidget {
  final String status;
  final IconData icon;
  final Color textColor;
  final Color iconColor;
  final Color backgroundColor;

  const StatusChip({
    super.key,
    required this.status,
    required this.icon,
    required this.textColor,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: textColor, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20.w,
            color: iconColor,
          ),
          const SizedBox(width: 8.0),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/*class QuantityProvider with ChangeNotifier {
  int _quantity = 1;

  int get quantity => _quantity;

  void increment() {
    _quantity++;
    notifyListeners();
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setQuantity(int newQuantity) {
    _quantity = newQuantity;
    notifyListeners();
  }
}

class QuantityControl extends StatelessWidget {
  const QuantityControl({super.key});

  @override
  Widget build(BuildContext context) {
    final quantityProvider = Provider.of<QuantityProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: .0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: Colors.grey, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: quantityProvider.decrement,
          ),
          Text(
            '${quantityProvider.quantity}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white.withOpacity(0.5),
            ),
            onPressed: quantityProvider.increment,
          ),
        ],
      ),
    );
  }
}*/