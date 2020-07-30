import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/wheather/complete_weather.dart';
import 'package:weather_app/screens/widgets/weather_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompleteWeatherFuture>(
      builder: (context, weather, child) {
        return FutureBuilder(
            future: weather.future,
            builder: (BuildContext context,
                AsyncSnapshot<CompleteWeather> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = [WeatherWidget()];
              } else if (snapshot.hasError) {
                //TODO show error message here
              } else {
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
              }
              return Scaffold(
                  appBar: AppBar(
                    title: Text("Weather"),
                    backgroundColor: Colors.cyanAccent,
                    actions: <Widget>[
                      IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            int i = Random().nextInt(4);
                            List<int> cityList = [
                              2867616,
                              1566083,
                              5128581,
                              6545177
                            ];
                            weather.reload(cityList[i]);
                            print("settings was pressed!");
                          })
                    ],
                  ),
                  body: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children),
                  ));
            });
      },
    );
  }
}
