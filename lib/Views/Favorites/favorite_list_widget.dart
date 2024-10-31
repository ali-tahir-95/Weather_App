import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/weather_controller.getx.dart';

class FavoriteListWidget extends StatelessWidget {
  final WeatherController controller = Get.find();

  FavoriteListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.favorites.isEmpty) {
        return const Center(child: Text("No favorites added")); // Message when no favorites
      }

      return ListView.builder(
        itemCount: controller.favorites.length,
        itemBuilder: (context, index) {
          final city = controller.favorites.keys.elementAt(index);
          final weather = controller.favorites[city]!;
          return ListTile(
            title: Text(city),
            subtitle: Text("Temp: ${weather.temperature}°C"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                controller.removeFavorite(city);
              },
            ),
          );
        },
      );
    });
  }
}
