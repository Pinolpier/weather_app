import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
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
          return Consumer<SharedPrefs>(
            builder: (context, prefs, child) {
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
                                  prefs.setInt("cityId", 0);
                                }
                              }
                            });
                          })
                    ],
                  ),
                  body: Center(
                      child: Container(
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
                                    child: WeatherWidget())),
                          ))));
            },
          );
        } else {
          return Column(
            children: <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 50,
                height: 50,
              ),
              Text("Checking GPS permission...")
            ],
          );
        }
      },
    );
  }
}
