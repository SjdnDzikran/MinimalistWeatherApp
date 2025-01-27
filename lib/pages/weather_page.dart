import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "loading city .."),
            Text('${_weather?.temperature.round().toString()}°C'),
          ],
        ),
      ),
    );
  }
}