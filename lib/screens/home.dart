import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/wheather/complete_weather.dart';
import 'package:weather_app/screens/settings.dart';
import 'package:weather_app/screens/widgets/weather_widget.dart';
import 'package:weather_app/services/SharedPrefs.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<GeolocationStatus> gpsAvailableCheck =
      Geolocator().checkGeolocationPermissionStatus();
  Widget gpsErrorWidget = Scaffold(
    appBar: AppBar(title: Text("Weather"), backgroundColor: Colors.green),
    body: Container(
      color: Colors.red,
      child: Center(
        child: Text(
          "ERROR:\nEither can not access GPS permission status or do not have GPS permission. Please grant access in settings to use the Weather App.",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gpsAvailableCheck,
      builder:
          (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
        if (snapshot.hasError) {
          return gpsErrorWidget;
        } else if (snapshot.hasData) {
          GeolocationStatus gpsStatus = snapshot.data;
          if (gpsStatus == GeolocationStatus.denied ||
              gpsStatus == GeolocationStatus.disabled ||
              gpsStatus == GeolocationStatus.unknown) {
            return gpsErrorWidget;
          }
          return Consumer<SharedPrefs>(builder: (context, prefs, child) {
            bool prefsChecked = false;
            return Consumer<CompleteWeatherService>(
              builder: (context, weatherService, child) {
                if (prefs.isAvailable() && !prefsChecked) {
                  int id = prefs.getInt("cityId");
                  id ??= 0;
                  prefsChecked = true;
                  weatherService.fetchWeather(id);
                }
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Weather"),
                    backgroundColor: Colors.green,
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => SettingsScreen()))
                                .then((context) {
                              if (prefs.isAvailable()) {
                                String i = prefs.getString("choosenLocation");
                                if (i == null || i.isEmpty) {
                                  prefs.setBool("useOwnLocation", true);
                                }
                              }
                            });
                          })
                    ],
                  ),
                  body: Center(
                    child: StreamBuilder(
                      stream: weatherService.getStream(),
                      initialData: null,
                      builder: (BuildContext context,
                          AsyncSnapshot<CompleteWeatherService> snapshot) {
                        List<Widget> children;
                        if (snapshot.hasError) {
                          children = [
                            Container(
                              color: Colors.red,
                              child: Text(
                                "Error has occured in home.dart",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            )
                          ];
                        } else if (snapshot.hasData) {
                          if (snapshot.data == null) {
                            // stream data equals inital data
                            children = [
                              SizedBox(
                                child: CircularProgressIndicator(),
                                width: 50,
                                height: 50,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Text("loading weather data."),
                              )
                            ];
                          } else {
                            if (prefs.isAvailable()) {
                              prefs.setInt("cityId",
                                  snapshot.data.weatherForecast.city.id);
                            }
                            children = [WeatherWidget()];
                          }
                        } else {
                          //Shouldn't happen!?
                        }
                        return Container(
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/background.jpg"),
                                  fit: BoxFit.cover)),
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                color: Colors.white38,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: children,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
                //   return FutureBuilder(
                //       future: weatherService.future,
                //       builder: (BuildContext context,
                //           AsyncSnapshot<CompleteWeatherService> snapshot) {
                //         List<Widget> children;
                //         if (snapshot.hasData) {
                //           if (prefs.isAvailable()) {
                //             prefs.setInt(
                //                 "cityId", snapshot.data.weatherForecast.city.id);
                //           }
                //           children = [WeatherWidget()];
                //         } else if (snapshot.hasError) {
                //           children = [
                //             Container(
                //               color: Colors.red,
                //               child: Text(
                //                 "Error has occured in home.dart",
                //                 style:
                //                     TextStyle(color: Colors.white, fontSize: 30),
                //               ),
                //             )
                //           ];
                //         } else {
                //           children = [
                //             SizedBox(
                //               child: CircularProgressIndicator(),
                //               width: 50,
                //               height: 50,
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(top: 20),
                //               child: Text("loading weather data."),
                //             )
                //           ];
                //         }
                //         return Scaffold(
                //             appBar: AppBar(
                //               title: Text("Weather"),
                //               backgroundColor: Colors.green,
                //               actions: <Widget>[
                //                 IconButton(
                //                     icon: Icon(Icons.settings),
                //                     onPressed: () {
                //                       // int i = Random().nextInt(4);
                //                       // List<int> cityList = [
                //                       //   2867616,
                //                       //   1566083,
                //                       //   5128581,
                //                       //   6545177
                //                       // ];
                //                       // weather.reload(cityList[i]);
                //                       // print("settings was pressed!");
                //                       Navigator.of(context)
                //                           .push(MaterialPageRoute(
                //                               builder: (context) =>
                //                                   SettingsScreen()))
                //                           .then((context) {
                //                         if (prefs.isAvailable()) {
                //                           String i =
                //                               prefs.getString("choosenLocation");
                //                           if (i == null || i.isEmpty) {
                //                             prefs.setBool("useOwnLocation", true);
                //                           }
                //                         }
                //                       });
                //                     })
                //               ],
                //             ),
                //             body: Center(
                //               child: Container(
                //                 constraints: BoxConstraints.expand(),
                //                 decoration: BoxDecoration(
                //                     image: DecorationImage(
                //                         image:
                //                             AssetImage("assets/background.jpg"),
                //                         fit: BoxFit.cover)),
                //                 child: ClipRRect(
                //                   child: BackdropFilter(
                //                     filter:
                //                         ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                //                     child: Container(
                //                       color: Colors.white38,
                //                       child: Center(
                //                         child: Column(
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.center,
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.center,
                //                             children: children),
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ));
                //       });
              },
            );
          });
        } else {
          return SizedBox(
            child: CircularProgressIndicator(),
            width: 50,
            height: 50,
          );
        }
      },
    );
  }
}
