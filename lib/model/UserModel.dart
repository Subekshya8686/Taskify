
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel? userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel? data) => json.encode(data!.toJson());

class UserModel {
  UserModel({
    this.id,
    this.userId,
    this.username,
    this.fcm,
    this.email,
    this.password,
  });

  String? id;
  String? userId;
  String? username;
  String? fcm;
  String? email;
  String? password;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    userId: json["user_id"],
    username: json["username"],
    fcm: json["fcm"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "username": username,
    "fcm": fcm,
    "email": email,
    "password": password,
  };
  factory UserModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => UserModel(
    id: json.id,
    userId: json["user_id"],
    username: json["username"],
    fcm: json["fcm"],
    email: json["email"],
    password: json["password"],
  );

}
