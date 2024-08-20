// lib/viewmodels/food_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/services/food_service.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';

class FoodViewModel extends ChangeNotifier {
  final FoodService _service = FoodService();
  List<Food> _foods = [];
  List<Food> _filteredFoods = [];

List<Food> get foods {
    if (_selectedFilters.isNotEmpty) {
      return _filteredFoods;
    }
    return _foods;
  }
  List<String> _selectedFilters = [];
  List<String> get selectedFilters => _selectedFilters;

  bool isLoading = false;
  UserViewModel userViewModel;

  FoodViewModel(this.userViewModel) {
    fetchFoods();
  }

  Future<void> refreshFoods() async {
    isLoading = true;
    notifyListeners();
     try {
      _foods = await _service.fetchFoods();
      await _service.cacheData(_foods);  // Cache the fetched data
       
    } catch (e) {
      Debugger.red('Error fetching foods: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFoods() async {
    isLoading = true;
    notifyListeners();

    try {
      Debugger.yellow('Attempting to fetch cached foods...');
      _foods = (await _service.getCachedData()) ;
     
      if (_foods.isEmpty) {
        Debugger.red('No food cached data found, fetching from server...');
        _foods = await _service.fetchFoods();
        await _service.cacheData(_foods);  // Cache the fetched data

      } else {
        Debugger.green('Loaded foods from cache.');
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      Debugger.red('Error fetching foods: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  //apply filter and return [] is filter no match 
  void applyFilters(List<String> filters) {
    _selectedFilters = filters;
    _filteredFoods = _foods.where((food) {
      return filters.any((filter) => food.category.contains(filter));
    }).toList();

    if (_filteredFoods.isEmpty) {
      _filteredFoods = [];
    }
    notifyListeners();
  }

  void removeFilter(String filter) {
    _selectedFilters.remove(filter);
    applyFilters(_selectedFilters);
  }

  List<Food> mergeFoods(List<Food> cached, List<Food> fetched) {
    final Map<String, Food> foodMap = {for (var e in cached) e.name: e};
    for (var food in fetched) {
      foodMap[food.name] = food;
    }
    return foodMap.values.toList();
  }
}