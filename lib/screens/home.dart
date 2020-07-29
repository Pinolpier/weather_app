import 'package:flutter/material.dart';

import 'package:weather_app/models/city/city.dart';
import 'package:weather_app/models/wheather/forecast.dart';
import 'package:weather_app/models/wheather/forecast_element.dart';
import 'package:weather_app/screens/widgets/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  City city;
  ForecastElement currentWeather;
  Forecast forecast;
  HomeScreen(this.city, this.currentWeather, this.forecast, {Key key})
      : super(key: key);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city.name),
        backgroundColor: Colors.cyanAccent,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // TODO Open settings screen
                print("Settings was pressed");
              })
        ],
      ),
      body: WeatherWidget(),
    );
  }
}
