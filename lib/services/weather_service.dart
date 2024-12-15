//http://api.weatherapi.com/v1/forecast.json?key=3aa24610523f41c199443356241412&q=Atlanta&days=1&aqi=no&alerts=yes
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_api.dart';

class WeatherService {
  Future<Weather> getWeatherData(String city) async {
    final uri = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=3aa24610523f41c199443356241412&q=$city&days=7&aqi=no&alerts=yes');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
