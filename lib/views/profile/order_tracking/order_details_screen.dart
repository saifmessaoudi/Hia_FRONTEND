import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hia/models/reservation.model.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/widgets/loading_scren_cart_order.dart';

class OrderDetailScreen extends StatelessWidget {
  final Reservation order;

  const OrderDetailScreen({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final EstablishmentViewModel establishmentViewModel = Provider.of<EstablishmentViewModel>(context, listen: false);
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
           if (cartViewModel.reOrderLoading) {
          return const LoadingScreenCart();
        } 
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
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
                          icon: Image.asset('images/left-arrow.png', width: 18.w, height: 18.w),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(90.0),
                          bottomRight: Radius.circular(90.0),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            FastCachedImage(
                              url: order.items.first.food.image, 
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250.0,
                              loadingBuilder: (context, loadingProgress) {
                                return loadingProgress.isDownloading && loadingProgress.totalBytes != null
                                    ? Shimmer(
                                        gradient: AppColors.shimmerGradient,
                                        child: Container(
                                          width: double.infinity,
                                          height: 250.0,
                                          color: AppColors.unselectedItemShadow,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: double.infinity,
                                        height: 250.0,
                                      );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    order.establishment?.name ?? 'Order Detail',
                                    style: AppStyles.interSemiBoldTextButton.black().withSize(FontSizes.headline3).withColor(AppColors.offWhite),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Gap(15),
                                  GestureDetector(
                                    onTap: () {
                                      final establishment = establishmentViewModel.establishments.firstWhere((element) => element.id == order.establishment?.id);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  EstablishmentDetailsScreen(establishment: establishment)));
                                    },
                                    child: Text(
                                      'See establishment >',
                                      style: AppStyles.interSemiBoldTextButton.light().withSize(FontSizes.headline6).withColor(AppColors.offWhite),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                order.status == 'Done'
                                    ? Image.asset(
                                        'images/favourite.png',
                                        width: 45.w,
                                        height: 45.w,
                                      )
                                    : Image.asset(
                                        'images/takeaway.png',
                                        width: 45.w,
                                        height: 45.w,
                                      ),
                                const Gap(25),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.status!,
                                        style: AppStyles.interSemiBoldTextButton.black().withColor(Colors.black).withSize(FontSizes.headline5).bold(),
                                      ),
                                      const Gap(10),
                                      Text(
                                        order.getFormattedDate(),
                                        style: AppStyles.interSemiBoldTextButton.medium().withColor(Colors.black).withSize(FontSizes.subtitle).bold(),
                                      ),
                                      Gap(2.h),
                                      Text(
                                        "Order Number: ${order.codeReservation}",
                                        style: AppStyles.interSemiBoldTextButton.regular().withColor(Colors.blueGrey).withSize(FontSizes.subtitle),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(20),
                          const ZigzagDivider(),
                          const Gap(20),
                          Text(
                            "Your Order",
                            style: AppStyles.interSemiBoldTextButton.black().withColor(Colors.black).withSize(FontSizes.headline3),
                          ),
                          const Gap(20),
                          Text(
                            "${order.items.length} items from ${order.establishment?.name}",
                            style: AppStyles.interSemiBoldTextButton.regular().withColor(Colors.blueGrey).withSize(FontSizes.title),
                          ),
                          const Gap(10),
                          _buildOrderItems(),
                          const Gap(20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
        
                    width: double.infinity,
                    child: ElevatedButton(
                      
                      onPressed: ()async {
                         final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
                      
                          cartViewModel.setReOrderLoading(true);
                          cartViewModel.clearCart();
                          await cartViewModel.addItems(order.items.map((item) => item.food).toList());
                          await cartViewModel.overrideEstablishmentId(order.establishment!.id);
                          
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 11.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                      ),
                      child: Text(
                        'Re-order',
                        style: AppStyles.interSemiBoldTextButton.withColor(AppColors.offWhite).withSize(FontSizes.headline5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
        );
      }
    );
  }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: order.items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item.quantity}x ${item.food.name}",
                style: AppStyles.interSemiBoldTextButton.medium().withColor(Colors.black).withSize(FontSizes.headline6),
              ),
              Text(
                "${item.food.price} DT",
                style: AppStyles.interSemiBoldTextButton.medium().withColor(Colors.black).withSize(FontSizes.headline6),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class ZigzagDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const ZigzagDivider({
    this.height = 7.0,
    this.width = double.infinity,
    this.color = const Color.fromARGB(224, 215, 215, 215),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _ZigzagPainter(color: color),
    );
  }
}

class _ZigzagPainter extends CustomPainter {
  final Color color;

  _ZigzagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final double segmentWidth = size.width / 25;

    for (double x = 0; x < size.width; x += segmentWidth) {
      path.moveTo(x, size.height);
      path.lineTo(x + segmentWidth / 2, 0);
      path.lineTo(x + segmentWidth, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}