import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import numpy as np
import matplotlib.pyplot as plt


void main() {
    # Generate data
np.random.seed(0)
x = np.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> weatherData;
  Location location = Location();
  bool _isLoading = false;

  Future<void> fetchWeatherData(double latitude, double longitude) async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLocationAndWeather();
  }

  Future<void> fetchLocationAndWeather() async {
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
      await fetchWeatherData(
        currentLocation.latitude,
        currentLocation.longitude,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : weatherData == null
              ? Center(
                  child: Text('No weather data available'),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Current Temperature: ${weatherData['main']['temp']}°C',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Description: ${weatherData['weather'][0]['description']}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
    );
  }
}
