import 'package:hia/models/market.model.dart';
import 'package:hia/models/product.model.dart';
import 'package:hive/hive.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 8;

  @override
Product read(BinaryReader reader) {
  final numOfFields = reader.readByte();
  final fields = <int, dynamic>{
    for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
  };

  return Product(
    id: fields[0] as String? ?? '',  
    name: fields[1] as String? ?? '',
    description: fields[2] as String?,
    price: (fields[3] as double?) ?? 0.0,
    image: fields[4] as String? ?? '',
    category: fields[5] as List<String>?,
    market: fields[6] is String 
        ? Market(id: fields[6] as String, name: '', latitude: 0.0, langitude: 0.0, isOpened: true , address: '',image: '',phone: '',products: [])
        : fields[6] as Market?,  // Handle as Market if it's an object
    isAvailable: (fields[7] as bool?) ?? false,
    remise: (fields[8] as double?) ?? 0.0,
    remiseDeadline: fields[9] as DateTime? ?? DateTime.now(),  
  );
}


  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.market)
      ..writeByte(7)
      ..write(obj.isAvailable)
      ..writeByte(8)
      ..write(obj.remise)
      ..writeByte(9)
      ..write(obj.remiseDeadline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
