import 'dart:convert';

class Review {
  String user;
  String comment;
  int rating;

  Review({required this.user, required this.comment, required this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      user: json['user'],
      comment: json['comment'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'comment': comment,
      'rating': rating,
    };
  }
}

class Food {
  final String id;
  final String name;
 final  String description;
  final double price;
  final String image;
  final String category;
  final String establishment;
  final List<Review> reviews;
  final double averageRating;
  final List<String> ingredients;
  final bool isAvailable;
  final double remise;
  final DateTime? remiseDeadline;

 Food({
    required this.id,
    required this.name,
    this.description = "",
    required this.price,
    this.image = "",
    required this.category,
    required this.establishment,
    this.reviews = const [],
    this.averageRating = 0.0,
    this.ingredients = const [],
    this.isAvailable = true,
    this.remise = 0.0,
    this.remiseDeadline,
  });

   factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id']?? '',
      name: json['name'],
      description: json['description'] ?? "",
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? "",
      category: json['category'],
      establishment: json['establishment'],
      reviews: (json['reviews'] as List).map((i) => Review.fromJson(i)).toList(),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      ingredients: (json['ingredients'] as List?)?.map((i) => i as String).toList() ?? [],
      isAvailable: json['isAvailable'] ?? true,
      remise: (json['remise'] as num?)?.toDouble() ?? 0.0,
      remiseDeadline: json['remiseDeadline'] != null ? DateTime.parse(json['remiseDeadline']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'establishment': establishment,
      'reviews': reviews.map((i) => i.toJson()).toList(),
      'averageRating': averageRating,
      'ingredients': ingredients,
      'isAvailable': isAvailable,
      'remise': remise,
      'remiseDeadline': remiseDeadline?.toIso8601String(),
    };
  }
}
