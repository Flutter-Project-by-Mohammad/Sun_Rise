import 'package:flutter/material.dart';
import 'package:test_12/Models/WeatherAPI.dart';

class WeatherCard extends StatelessWidget {
  final WeatherApi weather;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (weather.weather_icons.isNotEmpty)
                Image.network(
                  weather.weather_icons,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 50),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${weather.temperature}°C',
                      style: const TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      weather.weather_descriptions,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last updated: ${weather.observation_time}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoritePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
