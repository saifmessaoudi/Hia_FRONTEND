import 'package:flutter/foundation.dart';
import 'package:hia/helpers/debugging_printer.dart';
import 'package:hia/models/establishment.model.dart';
import 'package:hia/viewmodels/user_viewmodel.dart';
import '../services/establishment_service.dart';


class EstablishmentViewModel extends ChangeNotifier {
  final EstablishmentService _service = EstablishmentService();
  List<Establishment> establishments = [];
  List<Establishment> recommendedEstablishments = [];
  bool isLoading = false;
  UserViewModel userViewModel;

  EstablishmentViewModel(this.userViewModel) {
    fetchEstablishments();
  }

  Future<void> fetchEstablishments() async {
    isLoading = true;
    notifyListeners();

    try {
      Debugger.yellow('Attempting to fetch cached establishments...');
      establishments = (await _service.getCachedData()) as List<Establishment>;
      if (establishments.isEmpty) {
        Debugger.red('No cached data found, fetching from server...');
        establishments = await _service.fetchEstablishments();
      } else {
        Debugger.green('Loaded establishments from cache.');
        // Fetch new data from server and update cache
        List<Establishment> newEstablishments = await _service.fetchEstablishments();
        establishments = mergeEstablishments(establishments, newEstablishments);
        await _service.cacheData(establishments);
      }
      // Filter establishments based on user preferences
      establishments = filterByPreferences(establishments, userViewModel.foodPreference);
    } catch (e) {
      Debugger.red('Error fetching establishments: $e');
      // Handle error appropriately here (e.g., show a message to the user)
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Establishment> mergeEstablishments(List<Establishment> cached, List<Establishment> fetched) {
    final Map<String, Establishment> establishmentMap = {for (var e in cached) e.id: e};
    for (var establishment in fetched) {
      establishmentMap[establishment.id] = establishment;
    }
    return establishmentMap.values.toList();
  }

  List<Establishment> filterByPreferences(List<Establishment> establishments, List<String> preferences) {
    return establishments.where((establishment) {
      return establishment.preferences != null && establishment.preferences!.any((pref) => preferences.contains(pref));
    }).toList();
  }
}
