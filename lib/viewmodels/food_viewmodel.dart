import 'package:flutter/foundation.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/food.model.dart';
import 'package:hia/services/food_service.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';

class FoodViewModel extends ChangeNotifier {
  final FoodService _service = FoodService();
  List<Food> foods = [];
  bool isLoading = false;
  UserViewModel userViewModel;

  FoodViewModel(this.userViewModel) {
    fetchFoods();
  }

  Future<void> fetchFoods() async {
    isLoading = true;
    notifyListeners();

    try {
      Debugger.yellow('Attempting to fetch cached foods...');
      foods = (await _service.getCachedData()) ?? [];
      if (foods.isEmpty) {
        Debugger.red('No cached data found, fetching from server...');
        foods = await _service.fetchFoods();
        await _service.cacheData(foods);  // Cache the fetched data
      } else {
        Debugger.green('Loaded foods from cache.');
        // Fetch new data from server and update cache
        if (await _service.hasInternetConnection()) {
          List<Food> newFoods = await _service.fetchFoods();
          foods = mergeFoods(foods, newFoods);
          await _service.cacheData(foods);
        }
      }
    } catch (e) {
      Debugger.red('Error fetching foods: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Food> mergeFoods(List<Food> cached, List<Food> fetched) {
    final Map<String, Food> foodMap = {for (var e in cached) e.name: e};
    for (var food in fetched) {
      foodMap[food.name] = food;
    }
    return foodMap.values.toList();
  }
}
