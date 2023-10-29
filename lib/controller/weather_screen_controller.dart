import 'package:flutter/widgets.dart';

class WeatherConroller with ChangeNotifier {
  bool isSearchClicked = false;

  searchClicked() {
    isSearchClicked = !isSearchClicked;
    notifyListeners();
  }
}
