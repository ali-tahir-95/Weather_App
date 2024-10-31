import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class ApiService {
  static Future<Weather?> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      return null;
    }
  }
}
