import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../Constants/constants.dart';
import '../Services/api_service.service.dart';
import '../models/weather_model.dart';

class WeatherController extends GetxController {
  final cityController = TextEditingController();
  final weather = Rx<Weather?>(null);
  final favorites = <String, Weather>{}.obs;
  final box = GetStorage();

  void loadFavorites() {
    final storedFavorites = box.read<Map<String, dynamic>>('favorites') ?? {};
    favorites
        .assignAll(storedFavorites.map((key, value) => MapEntry(key, Weather.fromJson(value))));
  }

  Future<void> searchWeather(double latitude, double longitude) async {
    final result = await ApiService.fetchWeather(latitude, longitude);
    if (result != null) {
      weather.value = result;
    }
  }

  void addFavorite(String city, Weather weatherData) {
    favorites[city] = weatherData;
    box.write('favorites', favorites);
  }

  void removeFavorite(String city) {
    favorites.remove(city);
    box.write('favorites', favorites);
  }

  void sortFavoritesByTemperature({bool ascending = true}) {
    final sortedFavorites = favorites.entries.toList()
      ..sort((a, b) => ascending
          ? a.value.temperature.compareTo(b.value.temperature)
          : b.value.temperature.compareTo(a.value.temperature));
    favorites.assignAll(Map.fromEntries(sortedFavorites));
  }

  var loading = false.obs; // Add this line to track loading state

  Future<void> searchCityWeather() async {
    final city = cityController.text.trim().toLowerCase();
    loading.value = true; // Set loading to true before the search starts

    if (city.isEmpty) {
      loading.value = false; // Set loading to false on error
      Get.snackbar("Error", "Please enter a city name.");
      return;
    }

    if (cityCoordinates.containsKey(city)) {
      final latitude = cityCoordinates[city]!["latitude"]!;
      final longitude = cityCoordinates[city]!["longitude"]!;
      await searchWeather(latitude, longitude);
    } else {
      Get.snackbar("Error", "City not found.");
    }

    loading.value = false; // Set loading to false after the search completes
  }
}
