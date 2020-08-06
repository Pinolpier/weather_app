import 'dart:async';

import 'package:weather_app/models/wheather/current_and_daily_weather.dart';
import 'package:weather_app/models/wheather/daily.dart';
import 'package:weather_app/models/wheather/forecast.dart';
import 'package:weather_app/models/wheather/forecast_element.dart';
import 'package:weather_app/screens/widgets/custom_expansion_panel_radio.dart';
import 'package:weather_app/screens/widgets/forecast_widget.dart';
import 'package:weather_app/services/current_and_daily_weather_service.dart';
import 'package:weather_app/services/forecast_service.dart';

class CompleteWeatherService {
  final CurrentAndDailyWeather currentAndDailyWeather;
  final Forecast weatherForecast;
  int cityId = 0;
  List<CustomExpansionPanel> dayViews;
  StreamController<CompleteWeatherService> controller;
  CompleteWeatherService({
    this.currentAndDailyWeather,
    this.weatherForecast,
    this.dayViews,
  }) {
    controller = StreamController<CompleteWeatherService>.broadcast();
  }

  Stream<CompleteWeatherService> getStream() => controller.stream;

  Future<void> fetchWeather(int cityId) async {
    print("requested to fetch weather for $cityId");
    this.cityId = cityId;
    Forecast forecast = await fetchWeatherForecast(cityId);
    CurrentAndDailyWeather weather = await fetchCurrentAndDailyWeather(
        forecast.city.coord.lat, forecast.city.coord.lon);
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
    List<CustomExpansionPanel> dayPanels = [];
    for (Forecast i in days) {
      List<ForecastWidget> forecastWidgetList = [];
      if (i == null || i.list == null || i.list.isEmpty) {
        continue;
      }
      DateTime iDate =
          DateTime.fromMillisecondsSinceEpoch(i.list[0].timestamp * 1000);
      String weekday;
      switch (iDate.weekday) {
        case 1:
          weekday = "Monday";
          break;
        case 2:
          weekday = "Tuesday";
          break;
        case 3:
          weekday = "Wednesday";
          break;
        case 4:
          weekday = "Thursday";
          break;
        case 5:
          weekday = "Friday";
          break;
        case 6:
          weekday = "Saturday";
          break;
        case 7:
          weekday = "Sunday";
          break;
        default:
          weekday = "Error! Weekday can't be calculated!";
          break;
      }
      Daily day;
      for (Daily j in weather.daily) {
        DateTime jDate =
            DateTime.fromMillisecondsSinceEpoch(j.timestamp * 1000);
        if (iDate.day == jDate.day) {
          day = j;
          break;
        }
      }
      for (ForecastElement j in i.list) {
        forecastWidgetList.add(ForecastWidget(j));
      }
      dayPanels.add(CustomExpansionPanel(
        day: day,
        weekday: weekday,
        forecastWidgetList: forecastWidgetList,
      ));
    }
    controller.add(CompleteWeatherService(
        currentAndDailyWeather: weather,
        weatherForecast: forecast,
        dayViews: dayPanels));
  }

  Future<void> reload() async {
    return fetchWeather(this.cityId);
  }
}
