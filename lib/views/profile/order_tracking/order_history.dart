import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hia/models/reservation.model.dart';
import 'package:hia/viewmodels/reservation_viewmodel.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:provider/provider.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/app/style/app_constants.dart';
import 'package:hia/app/style/app_style.dart';
import 'package:hia/app/style/font_size.dart';
import 'package:hia/app/style/widget_modifier.dart';
import 'package:hia/widgets/back_row.dart';
import 'package:hia/widgets/smart_scaffold.dart';
import 'package:hia/widgets/styled_button.dart';
import 'package:shimmer/shimmer.dart';

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
    return ChangeNotifierProvider(
      create: (_) => ReservationViewModel()..getMyReservations(userId),
      child: SmartScaffold(
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
              tabs: [
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
                  _buildOrderList(context, "Completed"),
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
                onPressed: () {},
              ).paddingSymmetric(
                horizontal: AppConstants.bodyMinSymetricHorizontalPadding,
              ),
            );
          },
        ),
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
      height: MediaQuery.of(context).size.height / 5,
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
              Container(
                width: AppConstants.orderImageSize,
                height: AppConstants.orderImageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.orderImageRadius),
                  color: Colors.white,
                ),
                child: Image.network(
                  order.establishment?.image ?? "",
                  fit: BoxFit.contain,
                  width: 40.w,
                  height: 40.h,
                ).paddingSymmetric(horizontal: 6.w, vertical: 4.h),
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
          Gap(12.h),
          Divider(color: AppColors.greyRegular, thickness: AppConstants.dividerThickness),
          Gap(AppConstants.verticalSpacing),
        ],
      ).paddingSymmetric(
        horizontal: AppConstants.bodyMinSymetricHorizontalPadding,
        vertical: 16.h,
      ),
    ).paddingOnly(bottom: AppConstants.verticalSpacing);
  }
}