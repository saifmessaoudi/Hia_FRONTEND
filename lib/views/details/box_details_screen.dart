import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:hia/models/offer.model.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/views/details/establishment.details.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../constant.dart';

class BoxDetailsScreen extends StatefulWidget {
  const BoxDetailsScreen({super.key, required this.box});

  final Offer box;

  @override
  _BoxDetailsScreenState createState() => _BoxDetailsScreenState();
}

class _BoxDetailsScreenState extends State<BoxDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
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
                      url: widget.box.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300.0,
                      loadingBuilder: (context, loadingProgress) {
                        return loadingProgress.isDownloading &&
                                loadingProgress.totalBytes != null
                            ? Shimmer(
                                child: Container(
                                  width: double.infinity,
                                  height: 300.0,
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
                    Center(
                      child: Text(
                        widget.box.name,
                        style: AppStyles.interSemiBoldTextButton
                            .black()
                            .withSize(FontSizes.headline2)
                            .withColor(AppColors.offWhite),
                        textAlign: TextAlign.center,
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
                  const QuantityControl(),
                  const Gap(30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EstablishmentDetailsScreen(
                                establishment: widget.box.etablishment,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.background,
                              width: 2.0,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              widget.box.etablishment.image!,
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      StatusChip(
                        status: widget.box.isAvailable
                            ? 'Available'
                            : 'Not Available',
                        icon: Icons.lock_clock,
                        textColor: widget.box.isAvailable
                            ? AppColors.background
                            : Colors.red,
                        iconColor: widget.box.isAvailable
                            ? AppColors.background
                            : Colors.red,
                        backgroundColor: widget.box.isAvailable
                            ? AppColors.background.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                      ),
                      const SizedBox(width: 10),
                      StatusChip(
                        status: "${widget.box.quantity} items left",
                        icon: Icons.shopping_cart,
                        textColor: widget.box.quantity < 3
                            ? Colors.red
                            : AppColors.background,
                        iconColor: widget.box.quantity < 3
                            ? Colors.red
                            : AppColors.background,
                        backgroundColor: widget.box.quantity < 3
                            ? Colors.red.withOpacity(0.1)
                            : AppColors.background.withOpacity(0.1),
                      ),
                    ],
                  ),
                  const Gap(25),
                  // descript title 
                  Text(
                    'Description',
                    style: AppStyles.interSemiBoldTextButton
                        .medium()
                        .withSize(FontSizes.headline4).withColor(AppColors.offBlack),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),
                  Text(
                    widget.box.description,
                    style: kTextStyle.copyWith(
                      color: Colors.blueGrey,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.box.price} TND',
                        style: AppStyles.interSemiBoldTextButton
                            .bold()
                            .withSize(FontSizes.headline4).withColor(AppColors.offBlack),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Align(
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
                              offer:widget.box,
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
                  ),
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

class QuantityProvider with ChangeNotifier {
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
}
