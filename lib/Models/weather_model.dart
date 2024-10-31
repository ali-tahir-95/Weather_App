class Weather {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final List<double> hourlyTemperatures;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.hourlyTemperatures,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['current']['temperature_2m'] ?? 0.0,
      humidity: json['current']['relative_humidity_2m'] ?? 0.0,
      windSpeed: json['current']['wind_speed_10m'] ?? 0.0,
      hourlyTemperatures: List<double>.from(json['hourly']['temperature_2m'] ?? []),
    );
  }
}
