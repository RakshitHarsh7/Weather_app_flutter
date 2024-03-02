import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key

  final _weatherservice = WeatherService(dotenv.env['API_KEY']!);
  Weather? _weather;

  // fetch weather
  _fetchweather() async {
    // get the current city
    String cityName = await _weatherservice.getCurrentCity();

    // get weather for city

    try {
      final weather = await _weatherservice.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchweather();
  }

  String getWeatherAnimation(String? mainCondition, String? icon) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'fog':
        return 'assets/cloud.json';
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'mist':
        return 'aseets/mist.json';
      case 'clear':
        // If the icon ends with 'n', it's night time.
        if (icon?.endsWith('n') == true) {
          return 'assets/moon.json';
        } else {
          return 'assets/sunny.json';
        }
      case 'haze':
        return 'assets/mist.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Image.asset('assets/Icon-512.png'),
        ),
        title: const Text(
          'Mausam App',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.greenAccent,
            ),
            onPressed: () {
              setState(() {
                _weather = null;
              });
              _fetchweather();
            },
          ),
        ],
      ),
      body: _weather == null
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.greenAccent,
            ))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //city name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.greenAccent,
                        ),
                      ),
                      Text(
                        _weather?.cityName ?? "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  //animation
                  Container(
                    child: Lottie.asset(
                      getWeatherAnimation(
                          _weather?.mainCondition, _weather?.icon),
                      width: 260,
                    ),
                  ),

                  //temperature
                  const SizedBox(height: 30),
                  Text('${_weather?.temperature.round()}°C',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold)),

                  //weather condition
                  Text(_weather?.mainCondition ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),

                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Humidity',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.water_drop,
                            color: Colors.greenAccent,
                            size: 25,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _weather?.humidity.toString() ?? "",
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Wind Speed',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.wind_power,
                            color: Colors.greenAccent,
                            size: 25,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _weather?.windSpeed.toString() ?? "loading...",
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Pressure',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Icon(
                            Icons.air,
                            color: Colors.greenAccent,
                            size: 25,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _weather?.pressure.toString() ?? "",
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
