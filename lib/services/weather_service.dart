import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      print(response.body);
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // get permissions from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //convert the current location to a list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract the cityname from the first place mark
    String? city = placemarks[0].locality;

    return city ?? "";
  }

  Future<int> getHumidity(String cityName) async {
    final weather = await getWeather(cityName);
    return weather.humidity;
  }

  Future<double> getWindSpeed(String cityName) async {
    final weather = await getWeather(cityName);
    return weather.windSpeed;
  }
  Future<int> getPressure(String cityName) async {
    final weather = await getWeather(cityName);
    return weather.pressure;
  }
}
