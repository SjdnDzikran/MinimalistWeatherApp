import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimalist_weather_app/models/weather_model.dart';
import 'package:minimalist_weather_app/services/weather_service.dart';
import 'package:logger/logger.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService();
  final logger = Logger();
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    try {
      final weather = await _weatherService.getWeather();
      setState(() {
        _weather = weather;
      });
    }
    //any errors
    catch (e, stacktrace) {
      logger.e('Error Fetching weather: $e', error: e, stackTrace: stacktrace);
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String getWeatherIcon(String? weather) {
    switch (weather?.toLowerCase()) {
      case 'clouds':
      case 'fog':
        return 'assets/cloud.json';
      case 'haze':
      case 'dust':
        return 'assets/haze.json';
      case 'mist':
        return 'assets/mist.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'smoke':
        return 'assets/smoke.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _weather == null
            ? const Text("Loading...")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_weather!.cityName),
                  Lottie.asset(getWeatherIcon(_weather!.weatherCondition)),
                  Text('${_weather!.temperature.round()}°C'),
                  Text(_weather!.weatherCondition),
                ],
              ),
      ),
    );
  }
}