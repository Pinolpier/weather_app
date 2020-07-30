import 'package:flutter/material.dart';

import 'package:weather_app/models/wheather/forecast_element.dart';

class ForecastWidget extends StatefulWidget {
  final ForecastElement forecast;
  ForecastWidget(
    this.forecast, {
    Key key,
  }) : super(key: key);
  _ForecastWidgetState createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget> {
  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(
            widget.forecast.timestamp * 1000,
            isUtc: true)
        .toLocal();
    String timeString = (time.hour < 10 ? "0${time.hour}" : "${time.hour}") +
        ":" +
        (time.minute < 10 ? "0${time.minute}" : "${time.minute}");
    return Container(
      color: Colors.white24,
      child: Column(
        children: <Widget>[
          Text(timeString,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Image.asset(
            "assets/weather_icons/${widget.forecast.describedWeather.iconId}.png",
            width: 80,
            height: 80,
          ),
          Text("${widget.forecast.mainWeather.temperature}°C",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
