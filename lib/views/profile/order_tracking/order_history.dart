import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hia/models/reservation.model.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/viewmodels/reservation_viewmodel.dart';
import 'package:hia/views/card/cart_screen.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:hia/app/style/widget_modifier.dart';
import 'package:hia/views/home/home.dart';
import 'package:hia/views/reviews/review_screen.dart';
import 'package:hia/widgets/back_row.dart';
import 'package:hia/widgets/loading_scren_cart_order.dart';
import 'package:hia/widgets/styled_button.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserViewModel>(context).userData!.id;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationViewModel()..getMyReservations(userId)),
      ],
      child: Consumer<CartViewModel>(
        builder: (context, cartViewModel, child) {
          return Stack(
            children: [
              SmartScaffold(
                backgroundColor: AppColors.background,
                body: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, top: 20.h),
                      child: const BackRow(title: "Order History"),
                    ),
                    Gap(AppConstants.verticalSpacing),
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: "Pending Orders"),
                        Tab(text: "Completed Orders"),
                      ],
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.grey,
                      indicatorColor: AppColors.primary,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOrderList(context, "Pending"),
                          _buildOrderList(context, "Done"),
                        ],
                      ),
                    ),
                  ],
                ).paddingSymmetric(
                  horizontal: AppConstants.bodyMinSymetricHorizontalPadding,
                  vertical: AppConstants.minBodyTopPadding,
                ),
                floatingActionButton: Consumer<ReservationViewModel>(
                  builder: (context, orderHistoryViewModel, child) {
                    return Visibility(
                      visible: orderHistoryViewModel.myReservation.isEmpty,
                      child: StyledButton(
                        style: ButtonStyles.primary,
                        title: "Go to Marketplace",
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(initialIndex: 0,)));
                        },
                      ).paddingSymmetric(
                        horizontal: AppConstants.bodyMinSymetricHorizontalPadding,
                        vertical: 20.h,
                      ),
                    );
                  },
                ),
              ),
              if (cartViewModel.reOrderLoading)
                const LoadingScreenCart(),
            ],
          );
        },
      ),
    );
  }
  Widget _buildOrderList(BuildContext context, String status) {
    return Consumer<ReservationViewModel>(
      builder: (context, orderHistoryViewModel, child) {
        if (orderHistoryViewModel.isLoading) {
          return _buildShimmerEffect();
        }

        final orders = orderHistoryViewModel.myReservation.where((order) => order.status == status).toList();

        if (orders.isEmpty) {
          return const _EmptyHistory().center();
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return _HistoryItem(order: orders[index]);
          },
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: kMainColor,
          highlightColor: Colors.green[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.historyCardRadius),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "images/emptyCard.png",
          width: 80.w,
          height: 80.w,
        ),
        Gap(AppConstants.verticalSpacing),
        Text(
          "No orders yet",
          style: AppStyles.interSemiBoldTextButton.medium().withSize(FontSizes.headline4),
        ),
        Gap(12.h),
      ],
    ).paddingSymmetric(vertical: MediaQuery.of(context).size.height / 4);
  }
}

class _HistoryItem extends StatelessWidget {
  final Reservation order;
  const _HistoryItem({required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.date != null ? order.date!.toLocal().toString().split(" ")[0] : "";

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.historyCardRadius),
        gradient: AppColors.accountGradientClr,
        border: Border.all(color: AppColors.offWhite, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: AppConstants.orderImageSize,
                  height: AppConstants.orderImageSize,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: FastCachedImage(
                    url: order.establishment?.image ?? "",
                    fit: BoxFit.cover,
                    width: 40.w,
                    height: 40.h,
                    loadingBuilder: (context, loadingProgress) {
                      return loadingProgress.isDownloading && loadingProgress.totalBytes != null
                          ? Shimmer(
                              gradient: AppColors.shimmerGradient,
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                color: AppColors.unselectedItemShadow,
                              ),
                            )
                          : SizedBox(
                              width: 40.w,
                              height: 40.h,
                            );
                    },
                  ),
                ),
              ),
              Gap(16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${order.codeReservation}",
                    style: AppStyles.interSemiBoldTextButton.medium().withSize(FontSizes.headline6),
                  ),
                  Gap(8.w),
                  Text(
                    formattedDate,
                    style: AppStyles.interSemiBoldTextButton.medium().withColor(AppColors.grey).withSize(FontSizes.headline6),
                  ),
                ],
              ),
            ],
          ),
          Gap(AppConstants.verticalSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total price ",
                style: AppStyles.interSemiBoldTextButton.medium().withColor(AppColors.grey).withSize(FontSizes.headline6),
              ),
              Text(
                "\$${(order.totalPrice)?.toStringAsFixed(2)}",
                style: AppStyles.interSemiBoldTextButton.medium().withSize(FontSizes.headline6),
              ),
            ],
          ),
          Gap(10.h),
          Divider(color: AppColors.greyRegular, thickness: AppConstants.dividerThickness),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: order.items.map((item) => Text(
                  "* ${item.quantity} x ${item.food.name}",
                  style: AppStyles.interSemiBoldTextButton.medium().withSize(FontSizes.headline6),
                )).toList(),
              ),
              
            ],
          ),
          
          if (order.status == "Done") ...[
            Divider(color: AppColors.greyRegular, thickness: AppConstants.dividerThickness),
          
            Gap(AppConstants.verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  GestureDetector(
                  onTap: () async {
                    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
                
                    cartViewModel.setReOrderLoading(true);
                    cartViewModel.clearCart();
                    await cartViewModel.addItems(order.items.map((item) => item.food).toList());
                    await cartViewModel.overrideEstablishmentId(order.establishment!.id);
                    Future.delayed(const Duration(seconds: 2), () {
                      cartViewModel.setReOrderLoading(false);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                    });
                    
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_sharp,
                          color: AppColors.offWhite,
                          size: 18), 
                      const Gap(4),
                      Text(
                        "Re-order",
                        style: AppStyles.interregularTitle
                            .withSize(16.sp) 
                            .withColor(AppColors.offWhite)
                            .bold(),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap : (){
                      final firstFood = order.items.first.food;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewScreen( food: firstFood)));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star,
                          color: AppColors.offWhite,
                          size: 18), 
                      const Gap(4),
                      Text(
                        "Rate",
                        style: AppStyles.interregularTitle
                            .withSize(16.sp) 
                            .withColor(AppColors.offWhite)
                            .bold(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ).paddingSymmetric(
        horizontal: AppConstants.bodyMinSymetricHorizontalPadding,
        vertical: 16.h,
      ),
    ).paddingOnly(bottom: AppConstants.verticalSpacing);
  }
}