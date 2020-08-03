import 'package:flutter/material.dart';

import 'package:weather_app/models/wheather/current_and_daily_weather.dart';
import 'package:weather_app/models/wheather/forecast.dart';
import 'package:weather_app/models/wheather/forecast_element.dart';
import 'package:weather_app/screens/widgets/forecast_widget.dart';
import 'package:weather_app/services/current_and_daily_weather_service.dart';
import 'package:weather_app/services/current_weather_service.dart';
import 'package:weather_app/services/forecast_service.dart';

class CompleteWeather {
  final CurrentAndDailyWeather currentAndDailyWeather;
  final Forecast weatherForecast;
  List<Container> dayViews;
  CompleteWeather({
    this.currentAndDailyWeather,
    this.weatherForecast,
    this.dayViews,
  });

  static Future<CompleteWeather> reloadWeather(int cityId) async {
    Forecast forecast = await fetchWeatherForecast(cityId);
    CurrentAndDailyWeather weather = await fetchCurrentAndDailyWeather(
        forecast.city.coord.lat, forecast.city.coord.lon);
    // ForecastElement weather = await fetchCurrentAndDailyWeather(cityId);

    List<Forecast> days = [Forecast(city: forecast.city, list: [])];
    for (ForecastElement i in forecast.list) {
      if (days.last.list.isNotEmpty &&
          DateTime.fromMillisecondsSinceEpoch(
                      days.last.list.last.timestamp * 1000)
                  .day ==
              DateTime.fromMillisecondsSinceEpoch(i.timestamp * 1000).day) {
        days.last.list.add(i);
      } else if (days.isEmpty) {
        days[0] = Forecast(city: forecast.city, list: [i]);
      } else {
        days.add(Forecast(city: forecast.city, list: [i]));
      }
    }
    List<Container> k = []; //Liste von Containern,
    // die jeweils eine eigene ListView enthalten,
    // deren Children eine Liste von ForecastWidgets ist,
    // die selbst Container sind...
    for (Forecast i in days) {
      List<ForecastWidget> forecastWidgetList = [];
      int count = 0;
      for (ForecastElement j in i.list) {
        forecastWidgetList.add(ForecastWidget(j));
        count += 1;
      }
      if (forecastWidgetList.length != 0) {
        k.add(Container(
          height: 150,
          child: ListView.separated(
            padding: EdgeInsets.all(10),
            itemCount: forecastWidgetList.length,
            itemBuilder: (context, index) => forecastWidgetList[index],
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const Divider(
              indent: 5,
              endIndent: 5,
            ),
          ),
          color: Colors.white10,
        ));
      }
    }
    return CompleteWeather(
        currentAndDailyWeather: weather,
        weatherForecast: forecast,
        dayViews: k);
  }
}

class CompleteWeatherFuture extends ChangeNotifier {
  Future<CompleteWeather> future;
  CompleteWeatherFuture() {
    future = CompleteWeather.reloadWeather(//Thist is the first load to
        0); //ToDo change to current positions cityId
  }

  void reload(int cityId) {
    future = CompleteWeather.reloadWeather(cityId);
    notifyListeners();
  }
}
