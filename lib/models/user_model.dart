import 'dart:math';

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? crop;
  final String? variety;
  final String? profile;
  final DateTime? startDate;
  final DateTime? startDate2;
  final double? initialWeight;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.crop,
    this.variety,
    this.profile,
    this.startDate,
    this.startDate2,
    this.initialWeight,
  });

  static UserModel fromJson(Map<String,dynamic> json) => UserModel(
    uid: json['uid'],
    name: json['Name'],
    email: json['Email'],
    crop: json['Crop'],
    variety: json['Variety'],
    profile: json['Profile'],
    startDate: (json['Start Date']).toDate(),
    startDate2: json['Start Date 2'] == null ? null: (json['Start Date 2']).toDate(),
    initialWeight: double.parse(json['Initial Weight'].toString()),
  );

}