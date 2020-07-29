import 'dart:convert';

import 'package:weather_app/models/city/city.dart';
import 'package:weather_app/models/wheather/forecast_element.dart';

class Forecast {
  City city;
  List<ForecastElement> list;

  Forecast({
    this.city,
    this.list,
  });

  static Forecast fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    print(map['list']); //Liste von Forecast Objekten
    City city = City.fromMap(map['city']);
    List<ForecastElement> forecasts = List<ForecastElement>.from(
        map['list']?.map((x) => ForecastElement.fromMap(x)));
    return Forecast(
      city: city,
      list: forecasts,
    );
  }

  static Forecast fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Forecast(city: $city, list: $list)';
}
