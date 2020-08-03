import 'dart:convert';

import 'package:weather_app/models/wheather/current.dart';
import 'package:weather_app/models/wheather/daily.dart';

class CurrentAndDailyWeather {
  Current current;
  List<Daily> daily;
  CurrentAndDailyWeather({
    this.current,
    this.daily,
  });

  static CurrentAndDailyWeather fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CurrentAndDailyWeather(
      current: Current.fromMap(map['current']),
      daily: List<Daily>.from(map['daily']?.map((x) => Daily.fromMap(x))),
    );
  }

  static CurrentAndDailyWeather fromJson(String source) =>
      fromMap(json.decode(source));
}
