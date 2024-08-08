import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hia/app/style/app_colors.dart';
import 'package:hia/utils/connectivity_manager.dart';
import 'package:hia/views/home/exports/export_homescreen.dart';
import 'package:provider/provider.dart';
import 'connectivity_alert.dart'; // Import the new widget

class SmartScaffold extends StatefulWidget {
  const SmartScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor = Colors.white,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.displayBack = false,
    this.displayMenu = false,
    this.displayClose = false,
    this.isAuth = false,
    this.title,
    this.tilteColor = Colors.white,
    this.titleStyle,
    this.leadingIconData,
    this.leadingIconColor = Colors.white,
    this.onLeadingPressed,
    this.actionIconData,
    this.actionIconColor = Colors.white,
    this.actionBackgroundColor,
    this.onActionPressed,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.formKey,
  }) : super(key: key);

  final Widget body;
  final bool extendBody;
  final bool isAuth;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;

  final bool displayBack;
  final bool displayMenu;
  final bool displayClose;

  final String? title;
  final Color? tilteColor;
  final TextStyle? titleStyle;

  final IconData? actionIconData;
  final void Function()? onLeadingPressed;
  final IconData? leadingIconData;
  final Color? leadingIconColor;
  final Color? actionBackgroundColor;
  final Color? actionIconColor;
  final void Function()? onActionPressed;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final GlobalKey? formKey;

  @override
  _SmartScaffoldState createState() => _SmartScaffoldState();
}

class _SmartScaffoldState extends State<SmartScaffold> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startConnectivityCheck() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      final connectivityManager = Provider.of<ConnectivityManager>(context, listen: false);
      if (!connectivityManager.isConnected) {
        showConnectivityAlert(context, 'No Internet Connection');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        extendBody: widget.extendBody,
        key: widget.key,
        body: widget.isAuth
            ? Stack(
                children: [
                  Positioned(
                    child: Image.asset(
                      'images/hiaauthbgg.png',
                      width: 52,
                      height: 62,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Image.asset(
                      "images/hiaauthbgg.png",
                      width: 58,
                      height: 58,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Image.asset(
                      "images/hiaauthbgg.png",
                      width: 160,
                      height: 160,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Image.asset(
                      "images/hiaauthbgg.png",
                      width: 50,
                      height: 75,
                    ),
                  ),
                  widget.body,
                ],
              )
            : widget.body,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation ??
            (Platform.isIOS ? FloatingActionButtonLocation.endDocked : FloatingActionButtonLocation.endFloat),
        bottomSheet: widget.bottomSheet,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }
}
