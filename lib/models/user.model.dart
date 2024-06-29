class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phone;
  final bool isVerified;
  final String? profileImage;
  final String? address;
  final String? langitude;
  final String? latitude;
  final List<String> favoriteFood;
  final List<String> foodPreference;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phone,
    required this.isVerified,
    this.profileImage,
    this.address,
    this.langitude,
    this.latitude,
    required this.favoriteFood,
    required this.foodPreference,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'],
      isVerified: json['isVerified'] ?? false,
      profileImage: json['profileImage'],
      address: json['address'],
      langitude: json['langitude'],
      latitude: json['latitude'],
      favoriteFood: List<String>.from(json['favoriteFood'] ?? []),
      foodPreference: List<String>.from(json['foodPreference'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'isVerified': isVerified,
      'profileImage': profileImage,
      'address': address,
      'langitude': langitude,
      'latitude': latitude,
      'favoriteFood': favoriteFood,
      'foodPreference': foodPreference,
    };
  }
}
