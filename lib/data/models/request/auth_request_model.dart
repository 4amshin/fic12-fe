import 'dart:convert';

class AuthRequestModel {
  final String email;
  final String password;

  AuthRequestModel({
    required this.email,
    required this.password,
  });

  factory AuthRequestModel.fromRawJson(String str) =>
      AuthRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthRequestModel.fromJson(Map<String, dynamic> json) =>
      AuthRequestModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
