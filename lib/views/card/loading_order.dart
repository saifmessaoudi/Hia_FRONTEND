import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/utils/loading_widget.dart';
import 'package:hia/viewmodels/cart_viewmodel.dart';
import 'package:hia/viewmodels/reservation_viewmodel.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import 'package:hia/widgets/custom_toast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:hia/models/reservation.model.dart';

class LoadingScreenDialog extends StatefulWidget {
  const LoadingScreenDialog({super.key});

  @override
  _LoadingScreenDialogState createState() => _LoadingScreenDialogState();
}

class _LoadingScreenDialogState extends State<LoadingScreenDialog> {
  final ScreenshotController screenshotController = ScreenshotController();
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _addReservation());
  }

  void _addReservation() async {
    final cartViewModel = Provider.of<CartViewModel>(context, listen: false);
    final cartItems = cartViewModel.cart?.items ?? [];
    final establishmentId = cartViewModel.cart?.establishmentId;
    final userId =
        Provider.of<UserViewModel>(context, listen: false).userData!.id;

    final updatedItems = cartItems.map((item) {
    if (item.food != null) {
      item.type = 'food';
    } else if (item.offer != null) {
      item.type = 'offer';
    }
    return item;
  }).toList();

    // Create the reservation data
    final reservationData = Reservation(
      etablishmentId: establishmentId!,
      userId: userId,
      items: updatedItems,
    );

    final viewModel = Provider.of<ReservationViewModel>(context, listen: false);
    await viewModel.addReservation(reservationData);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationViewModel>(
      builder: (context, viewModel, child) {
        return Screenshot(
          controller: screenshotController,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: viewModel.isLoading  && viewModel.error == null
                  ? _buildLoadingScreen()
                  : _buildSuccessScreen(viewModel.reservationCode),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          'images/cart_animation.json',
          width: 60,
          height: 60,
        ),
        const SizedBox(height: 20),
        const LoadingWidget(color: AppColors.background, size: 13),
        const SizedBox(height: 20),
        const Text('Placing your order...'),
      ],
    );
  }

  Widget _buildSuccessScreen(String? reservationCode) {
      return RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (reservationCode == null)
                Column(
                  children: [
                    Lottie.asset(
                      'images/error_mark.json',
                      width: 80,
                      height: 80,
                      repeat: false,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Oops! Something went wrong.',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Lottie.asset(
                      'images/success_mark.json',
                      width: 60,
                      height: 60,
                      repeat: false,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Great! Enjoy your meal',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        text: 'Order code : ',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: reservationCode,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (reservationCode != null)
                GestureDetector(
                onTap: () async {
                  await _saveLocalImage();
                  showCustomToast(context, 'Screenshot saved to gallery');
                },
                child: Column(
                  children: [
                    Consumer<ReservationViewModel>(
                      builder: (context, viewModel, child) {
                        return viewModel.isLoadingScreenshot
                            ? const LoadingWidget(
                                color: AppColors.background, size: 10)
                            : Lottie.asset(
                                'images/screenshot_animation.json',
                                width: 60,
                                height: 60,
                              );
                      },
                    ),
                    const SizedBox(height: 10),
                    Consumer<ReservationViewModel>(
                      builder: (context, viewModel, child) {
                        return Text(
                          viewModel.isLoadingScreenshot
                              ? ''
                              : 'Screenshot me',
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

  Future<void> _saveLocalImage() async {
    final viewModel = Provider.of<ReservationViewModel>(context, listen: false);
    viewModel.setLoadingScreenshot(true);
    if (await Permission.storage.request().isGranted) {
      try {
        await Future.delayed(const Duration(milliseconds: 1000));

        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        double pixelRatio =
            MediaQuery.of(_globalKey.currentContext!).devicePixelRatio;
        ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
        ByteData? byteData =
            await (image.toByteData(format: ui.ImageByteFormat.png));
        if (byteData != null) {
          final result = await ImageGallerySaver.saveImage(
            byteData.buffer.asUint8List(),
            name: 'screenshot',
            isReturnImagePathOfIOS: true,
          );
          print(result);
        } else {
          print('ByteData is null');
        }
      } catch (e) {
        print('Error saving screenshot: $e');
      }
    }
    viewModel.setLoadingScreenshot(false);
    viewModel.clearAll();
  }
}
