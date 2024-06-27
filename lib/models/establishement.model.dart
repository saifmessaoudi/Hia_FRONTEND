class Establishment {
  final String id;
  final String name;
  final String description;
  final String image;
  final double langitude;
  final double latitude;
  final String address;
  final String phone;
  final double averageRating;
  final List<String> foods;
  final List<Review> reviews; // List of reviews
  final bool isOpened;

  Establishment({
    required this.id,
    required this.name,
    this.description = "",
    this.image = "",
    required this.langitude,
    required this.latitude,
    this.address = "",
    this.phone = "",
    this.averageRating = 0,
    required this.foods,
    required this.reviews, // Initialize with an empty list or handle null appropriately
    this.isOpened = true,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    var reviewList = json['reviews'] as List<dynamic>? ?? [];
    List<Review> parsedReviews = reviewList.map((e) => Review.fromJson(e)).toList();

    return Establishment(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      langitude: json['langitude'] != null ? json['langitude'].toDouble() : 0.0,
      latitude: json['latitude'] != null ? json['latitude'].toDouble() : 0.0,
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      averageRating: json['averageRating'] != null ? json['averageRating'].toDouble() : 0.0,
      foods: List<String>.from(json['foods'] ?? []),
      reviews: parsedReviews,
      isOpened: json['isOpened'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'langitude': langitude,
      'latitude': latitude,
      'address': address,
      'phone': phone,
      'averageRating': averageRating,
      'foods': foods,
      'reviews': reviews.map((review) => review.toJson()).toList(), // Convert reviews to JSON
      'isOpened': isOpened,
    };
  }
}

class Review {
  final String id;
  final String userId; // Assuming this is the ID of the user who posted the review
  final String comment;
  final int rating;

  Review({
    required this.id,
    required this.userId,
    required this.comment,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'comment': comment,
      'rating': rating,
    };
  }
}
