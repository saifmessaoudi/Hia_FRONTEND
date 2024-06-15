// lib/widgets/custom_dialog.dart

import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.transparent,  // fully transparent background
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: kMainColor,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 30), // space for the logo
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,  // make sure text is visible on transparent background
                  ),
                ),
                const SizedBox(height: 10),
               content != '' ? Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,  // make sure text is visible on transparent background
                  ),
                ) : const SizedBox.shrink(),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: onCancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(100, 40),
                      ),
                      child: const Text('Cancel', style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(100, 40),
                      ),
                      child: const Text('Yes' ,style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'images/h_logo.png',
                width: 60,
                height: 60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
