import 'dart:math';

class User {
  // String id;
  final String? name;
  final String? crop;
  final int? temperature;
  final int? relativeHumidity;
  final int? ethyleneConc;
  final int? co2Conc;
  final int? currentWeight;
  final DateTime? startDate;
  final int? initialWeight;

  User({
    // required this.id,
    this.name,
    this.crop,
    this.temperature,
    this.relativeHumidity,
    this.ethyleneConc,
    this.co2Conc,
    this.currentWeight,
    this.startDate,
    this.initialWeight,
  });

  static User fromJson(Map<String,dynamic> json) => User(
    // id: json['id'],
    name: json['Name'],
    crop: json['Crop'],
    temperature: json['Temperature'],
    relativeHumidity: json['Relative Humidity'],
    ethyleneConc: json['Ethylene Conc.'],
    co2Conc: json['CO2 Conc.'],
    currentWeight: json['Weight'],
    startDate: (json['Start Date']).toDate(),
    initialWeight: json['Initial Weight'],
  );

}