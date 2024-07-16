import 'package:hive/hive.dart';

part 'establishement.model.g.dart';

@HiveType(typeId: 3)
class Review extends HiveObject {
  @HiveField(0)
  String? user;

  @HiveField(1)
  String? comment;

  @HiveField(2)
  double rating;

  Review({this.user, this.comment, required this.rating});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      user: json['user'] as String?,
      comment: json['comment'] as String?,
      rating: (json['rating'] as num).toDouble(),
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


@HiveType(typeId: 2)
class Establishment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? image;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitude;

  @HiveField(6)
  String? address;

  @HiveField(7)
  double? averageRating;

  @HiveField(8)
  String? phone;

  @HiveField(9)
  bool isOpened;

  @HiveField(10)
  List<String>? preferences;

  @HiveField(11)
  List<String>? foods;

  @HiveField(12)
  List<Review>? reviews;

  Establishment({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.latitude,
    required this.longitude,
    this.address,
    this.averageRating,
    this.phone,
    required this.isOpened,
    this.preferences,
    this.foods,
    this.reviews,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['langitude'] as num).toDouble(),
      address: json['address'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      isOpened: json['isOpened'] as bool,
      preferences: (json['preferences'] as List<dynamic>?)?.map((e) => e as String).toList(),
      foods: (json['foods'] as List<dynamic>?)?.map((e) => e as String).toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'image': image,
      'latitude': latitude,
      'langitude': longitude,
      'address': address,
      'averageRating': averageRating,
      'phone': phone,
      'isOpened': isOpened,
      'preferences': preferences,
      'foods': foods,
      'reviews': reviews?.map((e) => e.toJson()).toList(),
    };
  }
}