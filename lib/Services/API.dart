import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_12/Models/WeatherAPI.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.weatherstack.com/current';
  static const String _accessKey = '4b4a0eae2662e189b768d5dd8218edb0';

  static Future<WeatherApi> getWeather(String city) async {
    final url = '$_baseUrl?access_key=$_accessKey&query=$city';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherApi.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load weather data. Status code: ${response.statusCode}',
      );
    }
  }
}
