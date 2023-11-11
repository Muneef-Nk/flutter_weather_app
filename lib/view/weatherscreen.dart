import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather/controller/weather_screen_controller.dart';
import 'package:weather/image_constants/images.dart';
import 'package:weather/services/location_provider.dart';
import 'package:weather/services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    String? placeName;

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    locationProvider.determinePosition().then((_) {
      if (locationProvider.currentLocation != null) {
        var city = locationProvider.currentLocation?.locality;

        print("city is: $city");
        if (city != null) {
          Provider.of<WeatherService>(context, listen: false)
              .fetchWeatherData(city);

          // Provider.of<LocationProvider>(context, listen: false)
          //     .changedPlace(city);

          setState(() {
            placeName = city;
          });
        }
      } else {
        // Handle the case when currentLocation is null
        print("Current location is null");
      }
    });

    // var provider = Provider.of<LocationProvider>(context);
    Provider.of<WeatherService>(context, listen: false)
        .fetchWeatherData(placeName ?? "");
    super.initState();
  }

  TextEditingController searchController = TextEditingController();

  String timestampConvert(int timestamp) {
    int timestamp =
        Provider.of<WeatherService>(context).weatherModel?.sys?.sunrise ?? 0;

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    String period = dateTime.hour < 12 ? 'AM' : 'PM';
    int hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;

    String formattedTime =
        "${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

    print("Formatted Time: $formattedTime");
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<WeatherConroller>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final weatherProvider = Provider.of<WeatherService>(context);

    String sunrise =
        timestampConvert(weatherProvider.weatherModel?.sys?.sunrise ?? 0);
//sunset
    String? sunset =
        timestampConvert(weatherProvider.weatherModel?.sys?.sunset ?? 0);

    String time = DateFormat("hh:mm a").format(DateTime.now());
    // print(time);
//  sunrise

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<WeatherService>(context, listen: false)
            .fetchWeatherData(Provider.of(context).currentPlace ?? "");
      },
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        // backgroundColor: Colors.black,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(background[
                      weatherProvider.weatherModel?.weather?[0].main ??
                          "Default"]),
                  fit: BoxFit.cover)),
          child: weatherProvider.isLoading
              ? Lottie.asset("assets/animation/loading.json")
              : Stack(children: [
                  Align(
                    alignment: Alignment(0, -0.85),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Consumer<LocationProvider>(
                                  builder: (context, LocationProvider, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locationProvider
                                              .currentLocation?.locality ??
                                          "Unknown location",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          time.contains("AM")
                                              ? "Good Morning"
                                              : "Good Evening",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat("hh:mm a")
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<WeatherConroller>(context,
                                        listen: false)
                                    .searchClicked();
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //search bar,
                  provider.isSearchClicked
                      ? Align(
                          alignment: Alignment(0, -0.7),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: searchController,
                              decoration: InputDecoration(
                                  fillColor: Colors.black.withOpacity(.6),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: "Search",
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      Provider.of<WeatherService>(context,
                                              listen: false)
                                          .fetchWeatherData(
                                              searchController.text);
                                      print(searchController.text);
                                    },
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // hintText: "Search place",
                                  // hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),

                  Align(
                    alignment: Alignment(0, -0.45),
                    child: Image.asset(
                      icons[weatherProvider.weatherModel?.weather?[0].main] ??
                          "Default",
                      width: 150,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.1),
                    child: Container(
                      width: 150,
                      height: 140,
                      // color: Colors.amber,
                      child: Column(children: [
                        Text(
                          searchController.text,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${weatherProvider.weatherModel?.main?.temp?.toStringAsFixed(0) ?? 0} \u00B0 C",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          weatherProvider.weatherModel?.weather?[0].main ??
                              "Not Found",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.7),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: size.width * 0.9,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //first row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //temp high
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/high.png",
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Temp Max",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          // "${weatherProvider.weatherModel?.main?.tempMax ?? 0}",
                                          "${weatherProvider.weatherModel?.main?.tempMax?.toStringAsFixed(0) ?? 0} \u00B0 C",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //temp low
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/low.png",
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Temp Min",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          // "${weatherProvider.weatherModel?.main?.tempMin ?? 0}",
                                          "${weatherProvider.weatherModel?.main?.tempMin?.toStringAsFixed(0) ?? 0} \u00B0 C",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //second row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/sunrise.webp",
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sunrise",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          sunrise,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/sunset.png",
                                      width: 50,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sunset",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          sunset,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                    ),
                  )
                ]),
        ),
      ),
    );
  }
}
