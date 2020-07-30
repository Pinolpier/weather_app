import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/models/wheather/complete_weather.dart';

class WeatherWidget extends StatefulWidget {
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompleteWeatherFuture>(
      builder: (context, future, child) {
        return FutureBuilder(
          future: future.future,
          builder:
              (BuildContext context, AsyncSnapshot<CompleteWeather> snapshot) {
            if (snapshot.hasData) {
              CompleteWeather weather = snapshot.data;
              return Center(
                child: Container(
                    color: Colors.limeAccent,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 500,
                          color: Colors.lightGreenAccent,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                                width: 50,
                              ),
                              Text(
                                "${weather.currentWeather.mainWeather.temperature}°C",
                                style: TextStyle(fontSize: 50.0),
                              ),
                              Text(
                                "Feels like ${weather.currentWeather.mainWeather.feelsLike}°C",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "${weather.weatherForecast.city.name}",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 30,
                                width: 50,
                              ),
                              Text(
                                weather.currentWeather.describedWeather
                                    .description,
                                style: TextStyle(fontSize: 20),
                              ),
                              Container(
                                child: Image.asset(
                                  "assets/weather_icons/${weather.currentWeather.describedWeather.iconId}.png",
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.lightGreenAccent,
                          height: 315,
                          child: ListView.separated(
                            itemCount: weather.dayViews.length,
                            itemBuilder: (context, index) =>
                                weather.dayViews[index],
                            scrollDirection: Axis.vertical,
                            separatorBuilder: (context, index) => const Divider(
                              indent: 30,
                              endIndent: 20,
                              height: 10,
                              thickness: 2.5,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    )),
              );
            } else if (snapshot.hasError) {
              //TODO error
            } else {
              return SizedBox(
                child: CircularProgressIndicator(),
                width: 50,
                height: 50,
              );
            }
          },
        );
      },
    );
    // List<Forecast> days = [Forecast(city: widget.city, list: [])];
    // for (ForecastElement i in widget.forecast.list) {
    //   if (days.last.list.isNotEmpty &&
    //       DateTime.fromMillisecondsSinceEpoch(
    //                   days.last.list.last.timestamp * 1000)
    //               .day ==
    //           DateTime.fromMillisecondsSinceEpoch(i.timestamp * 1000).day) {
    //     days.last.list.add(i);
    //   } else {
    //     days.add(Forecast(city: widget.city, list: [i]));
    //   }
    // }
    // List<Container> dayViews = [];
    // for (Forecast i in days) {
    //   List<ForecastWidget> forecastWidgetList = [];
    //   for (ForecastElement j in i.list) {
    //     forecastWidgetList.add(ForecastWidget(j));
    //   }
    //   dayViews.add(Container(
    //     child: ListView(
    //       scrollDirection: Axis.horizontal,
    //       children: forecastWidgetList,
    //     ),
    //     color: Colors.white10,
    //   ));
    // }
    // return Center(
    //   child: Container(
    //     color: Colors.limeAccent,
    //     child: Column(
    //       //crossAxisAlignment: CrossAxisAlignment.start,
    //       //mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Column(
    //           children: <Widget>[
    //             SizedBox(
    //               height: 70,
    //               width: 50,
    //             ),
    //             Text(
    //               "${widget.weather.mainWeather.temperature}°C",
    //               style: TextStyle(fontSize: 50.0),
    //             ),
    //             Text(
    //               "Fells like ${widget.weather.mainWeather.feelsLike}°C",
    //               style: TextStyle(fontSize: 20.0),
    //             ),
    //             SizedBox(
    //               height: 70,
    //               width: 50,
    //             ),
    //             Text(
    //               widget.weather.describedWeather.description,
    //               style: TextStyle(fontSize: 20.0),
    //             ),
    //             Container(
    //                 child: Image.asset(
    //                     "assets/weather_icons/${widget.weather.describedWeather.iconId}.png")),
    //             ListView(
    //               children: dayViews,
    //             )
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
