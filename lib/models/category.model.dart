import 'package:hia/models/food.model.dart';
import 'package:hia/models/user.model.dart';
import 'package:hive/hive.dart'; 


@HiveType(typeId: 9)
class Category  extends HiveObject {
  @HiveField(0)
  String id;
   @HiveField(1)
  String name;


  

  //constructor empty establishment
  Category.empty()
      : id = '',
        name = '';
       

  Category({
    required this.id,
    required this.name,
   
  });

  // establishment without foods
  

  factory Category.fromJson(Map<String, dynamic> json) {
  return Category(
    id: json['_id'] as String,
    name: json['name'] as String,

  );
   
}


  
}
