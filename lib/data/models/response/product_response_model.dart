// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:fic12_fe/data/models/response/category_response_model.dart';

class ProductResponseModel {
  final List<Product> data;

  ProductResponseModel({
    required this.data,
  });

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        data: List<Product>.from(json["data"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Product {
  final int? id;
  final String name;
  final int price;
  final int stock;
  // final String category;
  final Category category;
  final dynamic image;
  final bool isBestSeller;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.image,
    this.isBestSeller = false,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
        // category: json["category"],
        category: Category.fromMap(json["category"]),
        image: json["image"],
        isBestSeller: json["is_best_seller"] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        // "category": category,
        "category": category.toMap(),
        "image": image,
        "is_best_seller": isBestSeller ? 1 : 0,
      };

  Map<String, dynamic> toLocalMap() => {
        "id": id,
        "name": name,
        "price": price,
        "stock": stock,
        // "category": category,
        "category": category.name,
        "category_id": category.id,
        "image": image,
        "is_best_seller": isBestSeller ? 1 : 0,
      };

  Product copyWith({
    int? id,
    String? name,
    int? price,
    int? stock,
    // String? category,
    Category? category,
    String? image,
    bool? isBestSeller,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      image: image ?? this.image,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.price == price &&
        other.stock == stock &&
        other.category == category &&
        other.image == image &&
        other.isBestSeller == isBestSeller;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        stock.hashCode ^
        category.hashCode ^
        image.hashCode ^
        isBestSeller.hashCode;
  }
}
