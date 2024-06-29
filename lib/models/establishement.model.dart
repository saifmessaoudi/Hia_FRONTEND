import 'package:hive/hive.dart';


@HiveType(typeId: 0)
class Establishment extends HiveObject {
  final String id;
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final double langitude;
  @HiveField(4)
  final double latitude;
  @HiveField(5)
  final String address;
  @HiveField(6)
  final String phone;
  @HiveField(7)
  final double averageRating;
  @HiveField(8)
  final List<String> foods;
  @HiveField(9)
  final List<Review> reviews;
  @HiveField(10)
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
    required this.reviews,
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
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'isOpened': isOpened,
    };
  }
}

@HiveType(typeId: 1)
class Review extends HiveObject {
  final String id;
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String comment;
  @HiveField(2)
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

class EstablishmentAdapter extends TypeAdapter<Establishment> {
  @override
  final int typeId = 0; // Unique ID for this type in Hive

  @override
  Establishment read(BinaryReader reader) {
    return Establishment(
      id: reader.read() as String,
      name: reader.read() as String,
      description: reader.read() as String,
      image: reader.read() as String,
      langitude: reader.read() as double,
      latitude: reader.read() as double,
      address: reader.read() as String,
      phone: reader.read() as String,
      averageRating: reader.read() as double,
      foods: reader.read() as List<String>,
      reviews: reader.read() as List<Review>,
      isOpened: reader.read() as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Establishment obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.description)
      ..write(obj.image)
      ..write(obj.langitude)
      ..write(obj.latitude)
      ..write(obj.address)
      ..write(obj.phone)
      ..write(obj.averageRating)
      ..write(obj.foods)
      ..write(obj.reviews)
      ..write(obj.isOpened);
  }

  // ReviewAdapter can be nested inside EstablishmentAdapter
  static final ReviewAdapter _reviewAdapter = ReviewAdapter();

  // TypeAdapter implementation for Review class
  static TypeAdapter<Review> get reviewAdapter => _reviewAdapter;
}

class ReviewAdapter extends TypeAdapter<Review> {
  @override
  final int typeId = 1; // Unique ID for this type in Hive

  @override
  Review read(BinaryReader reader) {
    return Review(
      id: reader.read() as String,
      userId: reader.read() as String,
      comment: reader.read() as String,
      rating: reader.read() as int,
    );
  }

  @override
  void write(BinaryWriter writer, Review obj) {
    writer
      ..write(obj.id)
      ..write(obj.userId)
      ..write(obj.comment)
      ..write(obj.rating);
  }
}