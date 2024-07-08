import 'package:flutter/material.dart';
import 'package:hia/constant.dart';

class CustomToastWidget extends StatelessWidget {
  final String message;
  final bool isError;

  const CustomToastWidget({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isError ? const Color.fromARGB(255, 237, 71, 59) : kSecondaryColor;

    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Increased vertical padding
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12), // Increased border radius
            ),
            child: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40, // Adjusted width to fit screen width
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 3, // Limit the number of lines
                  overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                  textAlign: TextAlign.center, // Center align text
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showCustomToast(BuildContext context, String message, {bool isError = false}) {
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (BuildContext context) => CustomToastWidget(message: message, isError: isError),
  );

  Overlay.of(context).insert(overlayEntry);

  // Remove the overlay entry after a delay
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}