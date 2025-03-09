import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/secrets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/theme_provider.dart';
import 'additional_item_info.dart';
import 'hourly_weather.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = 'London'; // Default city

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
        ),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  // Function to open a dialog and get user input
  void _changeLocation() {
    TextEditingController cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shadowColor: Colors.white70,
          elevation: 10,
          title: Text("Enter City Name"),
          content: TextField(
            controller: cityController,
            decoration: InputDecoration(hintText: "e.g. London"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog without action
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cityName = cityController.text; // Update city name
                });
                Navigator.pop(context); // Close dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: _changeLocation, // Open location selection dialog
          icon: Icon(Icons.location_on),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).ThemeState();
            },
            icon: Icon(Icons.nightlight),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final data = snapshot.data!;
          final weatherData = data['list'][0];

          final currentTemp = weatherData['main']['temp'];
          final Currentweather = weatherData['weather'][0]['main'];
          final windspeed = weatherData['wind']['speed'];
          final humidity = weatherData['main']['humidity'];
          final pressure = weatherData["main"]['pressure'];

          final newTempCelsius = (currentTemp - 273.15).round();
          final newwindspeed = (windspeed * 3.6).round();

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    elevation: 18,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '$newTempCelsius °C',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          SizedBox(height: 4),
                          Icon(
                            Currentweather == 'Clouds' ||
                                Currentweather == 'Rain' ||
                                Currentweather == 'Clear'
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 64,
                          ),
                          SizedBox(height: 4),
                          Text(
                            Currentweather,
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Hourly Forecast",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i <= 5; i++)
                        HourlyWeather(
                          time: DateFormat('h:mm a').format(
                            DateTime.parse(data['list'][i + 1]['dt_txt']),
                          ),
                          icon: data['list'][i + 1]['weather'][0]['main'] ==
                              'Clouds' ||
                              data['list'][i + 1]['weather'][0]['main'] ==
                                  'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          val: data['list'][i + 1]['weather'][0]['main'],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Additional Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalItemInfo(
                      icon: Icons.water_drop,
                      lable: "Humidity",
                      num: '$humidity%',
                    ),
                    AdditionalItemInfo(
                      icon: Icons.air,
                      lable: "Wind Speed",
                      num: "$newwindspeed",
                    ),
                    AdditionalItemInfo(
                      icon: Icons.beach_access,
                      lable: "Pressure",
                      num: "$pressure",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
