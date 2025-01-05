import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:minimalist_weather_app/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;


class WeatherService {
  static const baseURL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$baseURL?=q$cityName&appid=$apiKey&units=metric'));

    if(response.statusCode == 200){
      return Weather.fromjson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCityName() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    //fetch current position
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high,)
    );

    //convert the location into a list of placemark objects
    List<Placemark> placemarks = 
      await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract the city name from the first placemark
    String? cityName = placemarks[0].locality;

    return cityName ?? "";
  }
}