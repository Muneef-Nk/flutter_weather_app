import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/splashscreen/splashscreen.dart';

import 'controller/weather_screen_controller.dart';
import 'services/location_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherConroller()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => WeatherService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'weather app',
        home: SpashScreen(),
      ),
    );
  }
}
