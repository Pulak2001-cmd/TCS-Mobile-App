////////////////////////////////////////////////////////////////
////// Model class to store User Data //////////////////////////
////////////////////////////////////////////////////////////////

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
  final String? foodItem;
  final String? endUse;

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
    this.foodItem,
    this.endUse,
  });

  /// function that converts the JSON data coming from Firebase to UserModel object
  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'],
        name: json['Name'],
        email: json['Email'],
        crop: json['Crop'],
        variety: json['Variety'],
        profile: json['Profile'],
        foodItem: json['foodItem'],
        startDate: (json['Start Date']).toDate(),
        endUse: json['End use'],
        startDate2: json['Start Date 2'] == null
            ? null
            : (json['Start Date 2']).toDate(),
        initialWeight: double.parse(json['Initial Weight'].toString()),
      );
}
