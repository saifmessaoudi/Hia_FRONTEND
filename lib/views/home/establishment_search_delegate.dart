import 'package:flutter/material.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/views/details/establishment.details.dart';
import 'package:hia/views/home/establishment_details.dart';

class EstablishmentSearchDelegate extends SearchDelegate<Establishment> {
  final EstablishmentViewModel establishmentViewModel;

  EstablishmentSearchDelegate(this.establishmentViewModel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
   return IconButton(
  icon: Icon(Icons.arrow_back),
  onPressed: () {
    close(context, Establishment(
      id: '',
      name: '',
      description: '',
      image: '',
      longitude: 0.0,
      latitude: 0.0,
      address: '',
      phone: '',
      averageRating: 0.0,
      foods: [],
      isOpened: true,
      reviews: [],  // Provide an empty list for the required 'reviews' parameter
    ));
  },
);



  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildEstablishmentList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildEstablishmentList();
  }

  Widget _buildEstablishmentList() {
    
    List<Establishment> filteredEstablishments = establishmentViewModel.establishments?.where((establishment) {
      return establishment.name.toLowerCase().contains(query.toLowerCase());
    }).toList() ?? [];

   return ListView.builder(
    
  itemCount: filteredEstablishments.length,
  itemBuilder: (context, index) {
    final establishment = filteredEstablishments[index];
    return ListTile(
      title: Text(
        establishment.name,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Row(
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.grey,
            size: 18.0,
          ),
          const SizedBox(width: 5.0), 
          Text(
            establishment.address ?? '',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      leading: establishment.image!.isNotEmpty
          ? Image.network(
              establishment.image ?? '',
              width: 70.0, 
              height: 70.0,
              fit: BoxFit.cover,
            )
          : null,
           trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
      ),
      onTap: () {
        // Navigate to ProductDetails screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EstablishmentDetailsScreen(establishment: establishment),
          ),
        );
      },
    );
  },
);

  }
}