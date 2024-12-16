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
  bool isAvailable;

  @HiveField(6)
  double remise;

  @HiveField(7)
  DateTime remiseDeadline;

  @HiveField(8)
  String market;

  @HiveField(9)
  String category; // Hier als String definiert

  // Standardkonstruktor
  Product.empty()
      : id = '',
        name = '',
        description = '',
        price = 0.0,
        image = '',
        isAvailable = false,
        remise = 0.0,
        remiseDeadline = DateTime.now(),
        market = '',
        category = '';

  // Hauptkonstruktor
  Product({
    required this.id,
    required this.name,
     this.description,
    required this.price,
    required this.image,
    required this.isAvailable,
    required this.remise,
    required this.remiseDeadline,
    required this.market,
    required this.category,
  });

  // Factory-Konstruktor zum Parsen von JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? false,
      remise: (json['remise'] as num?)?.toDouble() ?? 0.0,
      remiseDeadline: DateTime.parse(
          json['remiseDeadline'] as String? ?? '1970-01-01T00:00:00Z'),
      market: json['market'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }

  // Methode zum Konvertieren des Product-Objekts zurück zu JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'isAvailable': isAvailable,
      'remise': remise,
      'remiseDeadline': remiseDeadline.toIso8601String(),
      'market': market,
      'category': category,
    };
  }
}
