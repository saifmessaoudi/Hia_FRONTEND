import 'package:flutter/material.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';

class FoodPreferenceProvider with ChangeNotifier {
  final UserViewModel _userViewModel;

  FoodPreferenceProvider(this._userViewModel);
  final Map<String, bool> _selectedPreferences = {
    "Fast Food": false,
    "Vegan": false,
    "Sugar": false,
    "Nut-Free": false,
  };

  Map<String, bool> get selectedPreferences => _selectedPreferences;

  void togglePreference(String preference) {
    _selectedPreferences[preference] = !_selectedPreferences[preference]!;
    notifyListeners();
  }

  void savePreferences() {
    // Save preferences to the server

    //print from user id view model
    print(_userViewModel.userId);
  }
}
