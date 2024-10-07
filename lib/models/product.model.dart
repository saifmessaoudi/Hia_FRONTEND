import 'package:hia/models/market.model.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 8)
class Product extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  double price;

  @HiveField(4)
  String image;

  @HiveField(5)
  List<String>? category;

  @HiveField(6)
  Market? market; // Assuming it's the Market ID (ObjectId as String)

  @HiveField(7)
  bool isAvailable;

  @HiveField(8)
  double remise;

  @HiveField(9)
  DateTime? remiseDeadline;

  Product.empty()
      : id = '',
        name = '',
        description = '',
        price = 0.0,
        image = '',
        category = [],
        market = Market.empty(),
        isAvailable = true,
        remise = 0,
        remiseDeadline = null;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.image,
    this.category,
    required this.market,
    required this.isAvailable,
    required this.remise,
    this.remiseDeadline,
  });

factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String? ?? '',
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      isAvailable: json['isAvailable'] as bool? ?? false,
      remise: (json['remise'] as num?)?.toDouble() ?? 0.0,
      remiseDeadline: json['remiseDeadline'] != null
          ? DateTime.parse(json['remiseDeadline'])
          : null,
      market: Market.fromJsonWithoutProducts(json['market']),  // Include full market object
    );
  }







factory Product.fromJsonWithoutMarket(Map<String, dynamic> json) {
  return Product(
    id: json['_id'] as String? ?? '',  // Handle null id
    name: json['name'] as String? ?? '',  // Handle null name
    description: json['description'] as String? ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,  // Handle null safely
    image: json['image'] as String? ?? '',
    category: (json['category'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList() ?? [],  // Handle null safely
    isAvailable: json['isAvailable'] as bool? ?? false,
    remise: (json['remise'] as num?)?.toDouble() ?? 0.0,
    remiseDeadline: json['remiseDeadline'] != null
        ? DateTime.parse(json['remiseDeadline'])
        : null,
    market: null,  // No market details included in this factory
  );
}
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'market': market,
      'isAvailable': isAvailable,
      'remise': remise,
      'remiseDeadline': remiseDeadline?.toIso8601String(),
    };
  }
}
