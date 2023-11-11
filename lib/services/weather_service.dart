import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:weather/api_config/api_config.dart';
import 'package:weather/model/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService with ChangeNotifier {
  DataModel? weatherModel;
  String? error;
  bool isLoading = false;

  fetchWeatherData(String city) async {
    isLoading = true;
    notifyListeners();
    //https://api.openweathermap.org/data/2.5/weather?lat=57&lon=-2.15&appid={API key}&units=metric
    // "https://api.openweathermap.org/data/2.5/weather?q=kochi&appid=6ef4268c419e1efa6eb35c43332336dd&units=metric";
    try {
      final appUrl =
          "${ApiConfig().baseUrl}${city}&appid=${ApiConfig().api_key}&units=metric";
      final url = Uri.parse(appUrl);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        weatherModel = DataModel.fromJson(decodedData);
      } else {
        error = "failed to load data";
      }
    } catch (e) {
      error = "failed to load data $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
