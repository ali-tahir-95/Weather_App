import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondtest_app/Views/Favorites/favorite_list_widget.dart';
import '../../Constants/constants.dart';
import '../../Controllers/weather_controller.getx.dart';
import 'city_weather_widget.dart';

class HomePage extends StatelessWidget {
  final WeatherController controller = Get.put(WeatherController());
  final ValueNotifier<List<String>> suggestionsNotifier = ValueNotifier([]);

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Search and Favorites
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather Viewer",
          ),
          backgroundColor: Colors.amberAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Search'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Left Tab: Search UI
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller.cityController,
                      onChanged: (value) {
                        updateSuggestions(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Search All Cities of Italy',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // Call the search function
                            controller.searchCityWeather();
                          },
                        ),
                      ),
                    ),
                  ),
                  // Suggestions List
                  ValueListenableBuilder<List<String>>(
                    valueListenable: suggestionsNotifier,
                    builder: (context, suggestions, _) {
                      return suggestions.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: suggestions.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(suggestions[index]),
                                  onTap: () {
                                    controller.cityController.text = suggestions[index];
                                    suggestionsNotifier.value =
                                        []; // Clear suggestions after selection
                                    controller.searchCityWeather(); // Optionally trigger search
                                  },
                                );
                              },
                            )
                          : Container(); // Empty container if no suggestions
                    },
                  ),
                  Obx(() {
                    if (controller.loading.value) {
                      return const Center(
                          child: CircularProgressIndicator()); // Show loading indicator
                    } else if (controller.weather.value != null) {
                      return CityWeatherWidget(
                        weather: controller.weather.value!,
                        city: controller.cityController.text.trim(), // Pass the city name here
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),

            // Right Tab: Favorites UI
            FavoriteListWidget(),
          ],
        ),
      ),
    );
  }

  void updateSuggestions(String query) {
    // Update suggestions based on the input query
    final allCities = cityCoordinates.keys.toList();
    if (query.isEmpty) {
      suggestionsNotifier.value = [];
    } else {
      suggestionsNotifier.value =
          allCities.where((city) => city.startsWith(query.toLowerCase())).toList();
    }
  }
}
