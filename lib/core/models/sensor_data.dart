class SensorData {
  final double temperature;
  final double humidity;
  final double carbonMonoxide;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.carbonMonoxide,
  });

  bool get isTemperatureNormal => temperature >= 16 && temperature <= 35;
  bool get isHumidityNormal => humidity >= 40 && humidity <= 60;
  bool get isCarbonMonoxideNormal => carbonMonoxide <= 10;
}