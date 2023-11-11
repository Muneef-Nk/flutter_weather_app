import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/location_provider.dart';
import 'package:weather/services/weather_service.dart';
import 'package:weather/view/weatherscreen.dart';

class SpashScreen extends StatefulWidget {
  const SpashScreen({super.key});

  @override
  State<SpashScreen> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  @override
  void initState() {
    //
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WeatherScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("jknkjkn"),
    );
  }
}
