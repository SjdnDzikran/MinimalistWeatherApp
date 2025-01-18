import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:minimalist_weather_app/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static const baseURL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService() : apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';


    Future<Weather> getWeather() async {
      String cityName = await getCityName();

      final response = await http.get(Uri.parse('$baseURL?q=$cityName&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        return Weather.fromjson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    }

  Future<String> getCityName() async {
      try {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
          }

          Position position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
          );

          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          String? cityName = placemarks[0].locality;
          return cityName ?? "";

      } catch (e) {
          print('Error getting city name: $e');
          return "";
      }
  }

}