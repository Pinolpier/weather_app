import 'dart:convert';

import 'package:weather_app/models/wheather/described_weather.dart';
import 'package:weather_app/models/wheather/main_weather.dart';

class ForecastElement {
  int timestamp;
  MainWheater mainWheater;
  DescribedWheather describedWheather;
  ForecastElement({
    this.timestamp,
    this.mainWheater,
    this.describedWheather,
  });

  static ForecastElement fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ForecastElement(
      timestamp: map['dt'],
      mainWheater: MainWheater.fromMap(map['main']),
      describedWheather: DescribedWheather.fromMap(map['weather'][0]),
    );
  }

  static ForecastElement fromJson(String source) =>
      fromMap(json.decode(source));
}
