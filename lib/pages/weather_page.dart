import 'package:flutter/material.dart';
import 'package:minimalist_weather_app/models/weather_model.dart';
import 'package:minimalist_weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherService('bd5e378503939ddaee76f12ad7a97608');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCityName();

    //get weather info for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    
    //any errors
    catch (e) {
      print(e);
    }
  }
  
  //init state
  @override
  void initState() {
    // TODO: implement initState
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