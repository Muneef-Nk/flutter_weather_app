import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/view/weatherscreen.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'weather app',
        home: WeatherScreen(),
      ),
    );
  }
}
