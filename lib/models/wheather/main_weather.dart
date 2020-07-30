import 'dart:convert';

class MainWheater {
  double temperature;
  double feelsLike;
  int pressure;
  int humidity;
  MainWheater({
    this.temperature,
    this.feelsLike,
    this.pressure,
    this.humidity,
  });

  static MainWheater fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MainWheater(
      temperature: (map['temp'] * 10.0).round() / 10.0,
      feelsLike: (map['feels_like'] * 10.0).round() / 10.0,
      pressure: map['grnd_level'] != null ? map['grnd_level'] : map['pressure'],
      humidity: map['humidity'],
    );
  }

  static MainWheater fromJson(String source) => fromMap(json.decode(source));
}
