import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/weather_controller.getx.dart';
import '../../models/weather_model.dart';
import 'weather_chart_widget.dart';

class CityWeatherWidget extends StatelessWidget {
  final Weather weather;
  final String city; // Pass the city name to this widget

  const CityWeatherWidget({super.key, required this.weather, required this.city});

  @override
  Widget build(BuildContext context) {
    final WeatherController controller = Get.find<WeatherController>();

    return Card(
      child: Stack(
        children: [
          // Main Column with weather details
          Column(
            children: [
              Text("Temperature: ${weather.temperature}°C"),
              Text("Humidity: ${weather.humidity}%"),
              Text("Wind Speed: ${weather.windSpeed} km/h"),
              WeatherChartWidget(hourlyTemperatures: weather.hourlyTemperatures),
            ],
          ),

          // Positioned favorite button at the top right
          Positioned(
            top: 8.0,
            right: 8.0,
            child: IconButton(
              icon: const Icon(Icons.favorite_border), // or Icons.favorite for filled
              onPressed: () {
                controller.addFavorite(city, weather); // Call addFavorite
                Get.snackbar("Added to Favorites", "$city has been added to favorites.");
              },
            ),
          ),
        ],
      ),
    );
  }
}
