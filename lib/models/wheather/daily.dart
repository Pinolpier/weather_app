import 'dart:convert';

import 'package:weather_app/models/wheather/described_weather.dart';

class Daily {
  int timestamp;
  _DailyTemp temp;
  DescribedWheather describedWheather;
  Daily({
    this.timestamp,
    this.temp,
    this.describedWheather,
  });

  static Daily fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Daily(
      timestamp: map['dt'],
      temp: _DailyTemp.fromMap(map['temp']),
      describedWheather: DescribedWheather.fromMap(map['weather'][0]),
    );
  }

  static Daily fromJson(String source) => fromMap(json.decode(source));
}

class _DailyTemp {
  double min;
  double max;
  _DailyTemp({
    this.min,
    this.max,
  });

  static _DailyTemp fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return _DailyTemp(
      min: (map['min'] * 10.0).round() / 10.0,
      max: (map['max'] * 10.0).round() / 10.0,
    );
  }

  static _DailyTemp fromJson(String source) => fromMap(json.decode(source));
}
