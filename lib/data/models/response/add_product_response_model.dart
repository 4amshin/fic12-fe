import 'package:fic12_fe/data/models/response/product_response_model.dart';
import 'dart:convert';

class AddProductResponseModel {
  final Product data;

  AddProductResponseModel({
    required this.data,
  });

  factory AddProductResponseModel.fromJson(String str) =>
      AddProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddProductResponseModel.fromMap(Map<String, dynamic> json) =>
      AddProductResponseModel(
        data: Product.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}
