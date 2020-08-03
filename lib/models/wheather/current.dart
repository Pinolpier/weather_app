import 'dart:convert';

import 'package:weather_app/models/wheather/described_weather.dart';

class Current {
  int timestamp;
  double feelsLike;
  double temperature;
  DescribedWheather describedWeather;
  Current({
    this.timestamp,
    this.feelsLike,
    this.temperature,
    this.describedWeather,
  });

  static Current fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Current(
      timestamp: map['dt'],
      feelsLike: (map['feels_like'] * 10.0).round() / 10.0,
      temperature: (map['temp'] * 10.0).round() / 10.0,
      describedWeather: DescribedWheather.fromMap(map['weather'][0]),
    );
  }

  static Current fromJson(String source) => fromMap(json.decode(source));
}
