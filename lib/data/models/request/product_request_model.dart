import 'package:fic12_fe/data/models/response/category_response_model.dart';
import 'package:image_picker/image_picker.dart';

class ProductRequestModel {
  final String name;
  final int price;
  final int stock;
  final Category category;
  final XFile image;
  final int isBestSeller;

  ProductRequestModel({
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.image,
    required this.isBestSeller,
  });

  Map<String, String> toMap() {
    return <String, String>{
      'name': name,
      'price': price.toString(),
      'stock': stock.toString(),
      'category': category.toJson(),
      //image will be handled separately
      'is_best_seller': isBestSeller.toString(),
    };
  }
}
