import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/home.dart';
import 'package:weather_app/services/SharedPrefs.dart';

import 'models/wheather/complete_weather.dart';

Future<void> main() async {
  runApp(MultiProvider(
    providers: [
      Provider<CompleteWeatherService>(
          create: (context) => CompleteWeatherService()),
      ChangeNotifierProvider<SharedPrefs>(
          create: (BuildContext context) => SharedPrefs())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Roboto'),
      home: HomeScreen(),
    );
  }
}
