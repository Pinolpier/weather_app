import 'package:flutter/material.dart';

import 'package:weather_app/models/wheather/current_and_daily_weather.dart';
import 'package:weather_app/models/wheather/daily.dart';
import 'package:weather_app/models/wheather/forecast.dart';
import 'package:weather_app/models/wheather/forecast_element.dart';
import 'package:weather_app/screens/widgets/custom_expansion_panel_radio.dart';
import 'package:weather_app/screens/widgets/forecast_widget.dart';
import 'package:weather_app/services/current_and_daily_weather_service.dart';
import 'package:weather_app/services/current_weather_service.dart';
import 'package:weather_app/services/forecast_service.dart';

class CompleteWeather {
  final CurrentAndDailyWeather currentAndDailyWeather;
  final Forecast weatherForecast;
  // List<Container> dayViews;
  List<CustomExpansionPanel> dayViews;
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

    List<CustomExpansionPanel> dayPanels = [];
    // int uniqueIdentifier = 0;
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
      // Container body = Container(
      //   height: 140,
      //   child: ListView.separated(
      //     padding: EdgeInsets.all(10),
      //     itemCount: forecastWidgetList.length,
      //     itemBuilder: (context, index) => forecastWidgetList[index],
      //     scrollDirection: Axis.horizontal,
      //     separatorBuilder: (context, index) => const Divider(
      //       indent: 5,
      //       endIndent: 5,
      //     ),
      //   ),
      //   color: Colors.yellowAccent,
      // );
      // dayPanels.add(ExpansionPanelRadio(
      //     canTapOnHeader: true,
      //     body: body,
      //     headerBuilder: (BuildContext context, bool isExpanded) {
      //       return Container(
      //         color: Colors.purpleAccent,
      //         child: Row(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           mainAxisSize: MainAxisSize.min,
      //           children: <Widget>[
      //             Image.asset(
      //               "assets/weather_icons/${day.describedWheather.iconId}.png",
      //               width: 50,
      //               height: 50,
      //             ),
      //             SizedBox(width: 10),
      //             Text(weekday,
      //                 style:
      //                     TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      //             Expanded(child: Container()),
      //             Text("${day.temp.min}°C",
      //                 style:
      //                     TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      //             SizedBox(
      //               width: 10,
      //             ),
      //             Text("${day.temp.max}°C",
      //                 style:
      //                     TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      //           ],
      //         ),
      //       );
      //     },
      //     value: uniqueIdentifier));
      // uniqueIdentifier += 1;
    }
    // List<Container> k = []; //Liste von Containern,
    // // die jeweils eine eigene ListView enthalten,
    // // deren Children eine Liste von ForecastWidgets ist,
    // // die selbst Container sind...
    // for (Forecast i in days) {
    //   List<ForecastWidget> forecastWidgetList = [];
    //   int count = 0;
    //   for (ForecastElement j in i.list) {
    //     forecastWidgetList.add(ForecastWidget(j));
    //     count += 1;
    //   }
    //   if (forecastWidgetList.length != 0) {
    //     k.add(Container(
    //       height: 150,
    //       child: ListView.separated(
    //         padding: EdgeInsets.all(10),
    //         itemCount: forecastWidgetList.length,
    //         itemBuilder: (context, index) => forecastWidgetList[index],
    //         scrollDirection: Axis.horizontal,
    //         separatorBuilder: (context, index) => const Divider(
    //           indent: 5,
    //           endIndent: 5,
    //         ),
    //       ),
    //       color: Colors.white10,
    //     ));
    //   }
    // }
    return CompleteWeather(
        currentAndDailyWeather: weather,
        weatherForecast: forecast,
        dayViews: dayPanels);
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
