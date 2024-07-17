import 'package:hia/models/establishement.model.dart'; // Ensure correct import path
import 'package:hive/hive.dart';

part 'food.model.g.dart';

@HiveType(typeId: 0)
class Food extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final int price;

  @HiveField(3)
  final String image;

  @HiveField(4)
  final List<String> category;

  @HiveField(5)
  final int averageRating;

  @HiveField(6)
  final List<String> ingredients;

  @HiveField(7)
  final bool isAvailable;

  @HiveField(8)
  final int remise;

  @HiveField(9)
  final DateTime remiseDeadline;

  @HiveField(10)
  final List<Review>? reviews;

  @HiveField(11)
  final Establishment establishment; // Correct field name

  Food({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.averageRating,
    required this.ingredients,
    required this.isAvailable,
    required this.remise,
    required this.remiseDeadline,
    required this.reviews,
    required this.establishment, // Correct field name
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      category: List<String>.from(json['category']),
      averageRating: json['averageRating'],
      ingredients: List<String>.from(json['ingredients']),
      isAvailable: json['isAvailable'],
      remise: json['remise'],
      remiseDeadline: DateTime.parse(json['remiseDeadline']),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      establishment: Establishment.fromJson(json['etablishment']), // Correct key name
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'averageRating': averageRating,
      'ingredients': ingredients,
      'isAvailable': isAvailable,
      'remise': remise,
      'remiseDeadline': remiseDeadline.toIso8601String(),
      'reviews': reviews?.map((e) => e.toJson()).toList(),
      'etablishment': establishment.toJson(), // Correct key name
    };
  }
}
