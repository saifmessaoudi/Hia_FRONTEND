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
    };
  }

}
