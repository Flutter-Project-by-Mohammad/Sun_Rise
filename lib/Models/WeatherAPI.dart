class WeatherApi {
  final String name;
  final int temperature;
  final String observation_time;
  final String weather_descriptions;
  final String weather_icons;

  WeatherApi({
    required this.name,
    required this.temperature,
    required this.observation_time,
    required this.weather_descriptions,
    required this.weather_icons,
  });

  /// Creates a WeatherApi instance from JSON data
  factory WeatherApi.fromJson(Map<String, dynamic> json) {
    final weatherDescriptions = json['current']['weather_descriptions'] as List;
    final weatherIcons = json['current']['weather_icons'] as List;

    return WeatherApi(
      name: json['location']['name'] ?? 'Unknown',
      temperature: json['current']['temperature'] ?? 0,
      observation_time: json['current']['observation_time'] ?? 'Unknown time',
      weather_descriptions: weatherDescriptions.isNotEmpty
          ? weatherDescriptions[0]
          : 'No description',
      weather_icons: weatherIcons.isNotEmpty ? weatherIcons[0] : '',
    );
  }
}
