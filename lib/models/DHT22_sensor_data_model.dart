//////////////////////////////////////////////////
//////// Model class to store Sensor Data ////////
//////////////////////////////////////////////////

class DHT22SensorData {
  late DateTime timestamp;
  late double temperatureReading;
  late double humidityReading;
  late double? ethyleneConcReading;
  late double? co2ConcReading;

  /// Default class constructor
  DHT22SensorData({required this.timestamp, required this.temperatureReading, required this.humidityReading});

  /// Named constructor that assigns temperatureReading and humidityReading
  DHT22SensorData.fromJson(Map<dynamic, dynamic> json) :
    temperatureReading = json['temperature'].runtimeType == int ? json['temperature'].toDouble() : json['temperature'] as double,
    humidityReading = json['humidity'].runtimeType == int ? json['humidity'].toDouble(): json['humidity'] as double,
    ethyleneConcReading = json['etheleneConc'] == null? null : json['etheleneConc'].runtimeType == int ? json['etheleneConc'].toDouble() : json['etheleneConc'] as double,
    co2ConcReading = json['CO2Conc'] == null ? null : json['CO2Conc'].runtimeType == int ? json['CO2Conc'].toDouble(): json['CO2Conc'] as double;

  /// Function that checks if the incoming value from sensor data is NULL or a valid value
  static bool checkValidValue(Map<dynamic, dynamic> json){
    if (json['temperature'].runtimeType != Null && json['humidity'].runtimeType != Null){
      return true;
    } else {
      return false;
    }
  }
}