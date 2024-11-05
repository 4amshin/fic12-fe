// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryResponseModel {
  final bool status;
  final String message;
  final List<Category> data;

  CategoryResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponseModel.fromJson(String str) =>
      CategoryResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryResponseModel.fromMap(Map<String, dynamic> json) {
    return CategoryResponseModel(
      status: json['status'],
      message: json['message'],
      data: List<Category>.from(json["data"].map((x) => Category.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'data': List<dynamic>.from(data.map((x) => x.toMap())),
    };
  }
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  Map<String, dynamic> toLocal() {
    return <String, dynamic>{
      'category_id': id,
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  factory Category.fromLocal(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'] as int,
      name: json['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));
}
