import 'package:hia/models/product.model.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 7)
class Market extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? image;

  @HiveField(3)
  double langitude;

  @HiveField(4)
  double latitude;  // Ensure this matches the backend `langitude`

  @HiveField(5)
  String? address;

  @HiveField(6)
  String? phone;

 

  @HiveField(7)
  List<Product>? products;


   @HiveField(8)
  bool isOpened;

  Market.empty()
      : id = '',
        name = '',
        image = '',
        latitude = 0.0,
        langitude = 0.0,
        address = '',
        phone = '',
        isOpened = true,
        products = [];

  Market({
    required this.id,
    required this.name,
    this.image,
    required this.latitude,
    required this.langitude,
    this.address,
    this.phone,
    required this.isOpened,
    this.products,
  });


 factory Market.fromJsonWithoutProducts(Map<String, dynamic> json) {
    return Market(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble() ?? 0.0,
      langitude: (json['langitude'] as num).toDouble() ?? 0.0,
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isOpened: json['isOpened'] as bool ?? false,
     
    );
  }

factory Market.fromJson(Map<String, dynamic> json) {
  return Market(
    id: json['_id'] as String? ?? '',  // Default to empty string if null
    name: json['name'] as String? ?? '',  // Default to empty string if null
    image: json['image'] as String? ?? '',  // Handle null values for image
    langitude: (json['langitude'] as num?)?.toDouble() ?? 0.0,  // Handle null safely
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,  // Handle null safely
    address: json['address'] as String? ?? '',  // Default to empty string if null
    phone: json['phone'] as String? ?? '',  // Handle null for phone
    isOpened: json['isOpened'] as bool? ?? false,  // Default to false if null
    products: (json['products'] as List<dynamic>?)
        ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList() ?? [],  // Default to empty list if null
  );
}



  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'latitude': latitude,
      'langitude': langitude,
      'address': address,
      'phone': phone,
      'isOpened': isOpened,
      'products': products,
    };
  }
}
