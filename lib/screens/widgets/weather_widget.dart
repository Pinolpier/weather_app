import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:weather_app/models/wheather/complete_weather.dart';
import 'package:weather_app/screens/widgets/forecast_list_widget.dart';

class WeatherWidget extends StatefulWidget {
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompleteWeatherService>(
      builder: (context, weatherService, child) {
        return StreamBuilder(
          stream: weatherService.getStream(),
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                color: Colors.red,
                child: Text(
                  "Error has occured in weather_widget.dart",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              );
            } else if (snapshot.hasData) {
              CompleteWeatherService weather = snapshot.data;
              if (weather == null) {
                //initial data, no weather fetched so far
                return SizedBox(
                  child: CircularProgressIndicator(),
                  width: 50,
                  height: 50,
                );
              }
              return Center(
                child: Container(
                    child: Column(
                  children: <Widget>[
                    RefreshIndicator(
                      onRefresh: () => weatherService.reload(),
                      child: Container(
                        height: 276,
                        width: 500,
                        child: ListView(
                          children: [
                            Container(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                    width: 50,
                                  ),
                                  Text(
                                    "${weather.currentAndDailyWeather.current.temperature}°C",
                                    style: TextStyle(
                                        fontSize: 50.0, color: Colors.black),
                                  ),
                                  Text(
                                    "Feels like ${weather.currentAndDailyWeather.current.feelsLike}°C",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  Text(
                                    "${weather.weatherForecast.city.name}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 50,
                                  ),
                                  Text(
                                    weather.currentAndDailyWeather.current
                                        .describedWeather.description,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                  Container(
                                    child: Image.asset(
                                      "assets/weather_icons/${weather.currentAndDailyWeather.current.describedWeather.iconId}.png",
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 315,
                      child: ForecastListWidget(
                        list: weather.dayViews,
                      ),
                    ),
                  ],
                )),
              );
            } else {
              //this should never happen!?
            }
          },
        );
        // return FutureBuilder(
        //   future: weatherService.future,
        //   builder: (BuildContext context,
        //       AsyncSnapshot<CompleteWeatherService> snapshot) {
        //     if (snapshot.hasData) {
        //       CompleteWeatherService weather = snapshot.data;
        //       return Center(
        //         child: Container(
        //             // color: Colors.limeAccent,
        //             child: Column(
        //           children: <Widget>[
        //             RefreshIndicator(
        //               onRefresh: () => weatherService.update(),
        //               child: Container(
        //                 height: 276,
        //                 width: 500,
        //                 // color: Colors.lightGreenAccent,
        //                 child: ListView(
        //                   children: [
        //                     Container(
        //                       child: Column(
        //                         children: <Widget>[
        //                           SizedBox(
        //                             height: 20,
        //                             width: 50,
        //                           ),
        //                           Text(
        //                             "${weather.currentAndDailyWeather.current.temperature}°C",
        //                             style: TextStyle(
        //                                 fontSize: 50.0, color: Colors.black),
        //                           ),
        //                           Text(
        //                             "Feels like ${weather.currentAndDailyWeather.current.feelsLike}°C",
        //                             style: TextStyle(
        //                                 fontSize: 20, color: Colors.black),
        //                           ),
        //                           Text(
        //                             "${weather.weatherForecast.city.name}",
        //                             style: TextStyle(
        //                                 fontSize: 15, color: Colors.black),
        //                           ),
        //                           SizedBox(
        //                             height: 30,
        //                             width: 50,
        //                           ),
        //                           Text(
        //                             weather.currentAndDailyWeather.current
        //                                 .describedWeather.description,
        //                             style: TextStyle(
        //                                 fontSize: 20, color: Colors.black),
        //                           ),
        //                           Container(
        //                             child: Image.asset(
        //                               "assets/weather_icons/${weather.currentAndDailyWeather.current.describedWeather.iconId}.png",
        //                               width: 100,
        //                               height: 100,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             Container(
        //               height: 315,
        //               // child: ListView.separated(
        //               //   itemCount: weather.dayViews.length,
        //               //   itemBuilder: (context, index) =>
        //               //       weather.dayViews[index],
        //               //   scrollDirection: Axis.vertical,
        //               //   separatorBuilder: (context, index) => const Divider(
        //               //     indent: 30,
        //               //     endIndent: 20,
        //               //     height: 10,
        //               //     thickness: 2.5,
        //               //     color: Colors.black,
        //               //   ),
        //               // ),
        //               child: ForecastListWidget(
        //                 list: weather.dayViews,
        //               ),
        //             ),
        //           ],
        //         )),
        //       );
        //     } else if (snapshot.hasError) {
        //       return Container(
        //         color: Colors.red,
        //         child: Text(
        //           "Error has occured in weather_widget.dart",
        //           style: TextStyle(color: Colors.white, fontSize: 30),
        //         ),
        //       );
        //     } else {
        //       return SizedBox(
        //         child: CircularProgressIndicator(),
        //         width: 50,
        //         height: 50,
        //       );
        //     }
        //   },
        // );
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
