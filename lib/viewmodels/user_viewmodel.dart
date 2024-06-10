import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hia/services/user_service.dart';

class UserViewModel extends ChangeNotifier {

final UserService userService = UserService() ; 

    String? _validateEmail(String? value) {
    if (value == null ||
        !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }




  }

