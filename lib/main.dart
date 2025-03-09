import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/weather_screen.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Fixed: Changed theme() to ThemeProvider()
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.themeData, // Fixed: Changed theme.themeData to themeProvider.themeData
          debugShowCheckedModeBanner: false,
          home: WeatherScreen(),
        );
      },
    );
  }
}
