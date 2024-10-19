import 'dart:convert';

class AuthResponseModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String jwtToken;

  AuthResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.jwtToken,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        jwtToken: json["jwt-token"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "jwt-token": jwtToken,
      };
}
