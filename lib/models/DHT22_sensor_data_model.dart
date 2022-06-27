class DHT22SensorData {
  late DateTime timestamp;
  late double temperatureReading;
  late double humidityReading;

  DHT22SensorData({required this.timestamp, required this.temperatureReading, required this.humidityReading});

  DHT22SensorData.fromJson(Map<dynamic, dynamic> json) :
    temperatureReading = json['temperature'].runtimeType == int ? json['temperature'].toDouble() : json['temperature'] as double,
    humidityReading = json['humidity'].runtimeType == int ? json['humidity'].toDouble(): json['humidity'] as double;
}