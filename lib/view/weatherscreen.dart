import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/controller/weather_screen_controller.dart';
import 'package:weather/services/location_provider.dart';

class WeatherScreen extends StatefulWidget {
  WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    Provider.of<LocationProvider>(context, listen: false).determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<WeatherConroller>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background/thunder.jpg"),
                fit: BoxFit.cover)),
        child: Stack(children: [
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
                              locationProvider.currentLocationName?.locality ??
                                  "Unkown location",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              locationProvider.currentLocationName?.country ??
                                  "",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
                        Provider.of<WeatherConroller>(context, listen: false)
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
                      decoration: InputDecoration(
                          // hintText: "Search place",
                          // hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                )
              : SizedBox.shrink(),

          Align(
            alignment: Alignment(0, -0.45),
            child: Image.asset(
              "assets/icons/clouds_icon.png",
              width: 150,
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Container(
              width: 150,
              height: 100,
              // color: Colors.amber,
              child: Column(children: [
                Text(
                  "20  C ",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Cloud",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "2:30 pm IST",
                  style: TextStyle(fontSize: 15, color: Colors.white),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Temp Max",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "21 C",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Temp Max",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "21 C",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sunrise",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "6:88 AM",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Temp Max",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "21 C",
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
                  ]),
            ),
          )
        ]),
      ),
    );
  }
}
