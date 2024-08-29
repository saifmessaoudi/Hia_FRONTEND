import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hia/constant.dart';
import 'package:hia/models/establishement.model.dart';
import 'package:hia/viewmodels/establishement_viewmodel.dart';
import 'package:hia/views/details/establishment.details.dart';

class EstablishmentSearchDelegate extends SearchDelegate<Establishment> {
  final EstablishmentViewModel establishmentViewModel;

  EstablishmentSearchDelegate(this.establishmentViewModel);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query.isEmpty ? close(context, Establishment(
            id: '',
            name: '',
            description: '',
            image: '',
            longitude: 0.0,
            latitude: 0.0,
            address: '',
            phone: '',
            averageRating: 0,
            foods: [],
            isOpened: true,
            reviews: [],  
          )) : query = '';
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
          averageRating: 0,
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
    List<Establishment> filteredEstablishments = establishmentViewModel.establishments.where((establishment) {
      return establishment.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Container(
      color: Colors.white, // Set the background color to white
      child: ListView.builder(
        itemCount: filteredEstablishments.length,
        itemBuilder: (context, index) {
          final establishment = filteredEstablishments[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10.0),
                title: Text(
                  establishment.name,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Row(
                  children: [
                     //stars icon 
                   const  Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 15.0,
                    ),
                    const SizedBox(width: 5.0),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: establishment.averageRating!.toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 10.0,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          establishment.averageRating.toString(),
                          style: kTextStyle.copyWith(color: kGreyTextColor),
                        ),
                      ],
                    ),

                  ],
                ),
                leading: establishment.image!.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: establishment.image ?? '',
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
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
              ),
            ),
          );
        },
      ),
    );
  }
}