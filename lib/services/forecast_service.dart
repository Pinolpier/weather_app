import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/wheather/forecast.dart';

Future<Forecast> fetchWeatherForecast(int cityId) async {
  http.Response response;
  if (cityId != 0) {
    response = await http
        .get(
            "https://api.openweathermap.org/data/2.5/forecast?id=$cityId&units=metric&appid=7328c736ae7355ac59b28bf4a1ce2d68")
        .timeout(const Duration(milliseconds: 5000));
  } else {
    //Weather for current location is expected
    Position position;
    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } on PlatformException catch (e) {
      print(
          "ERROR: Couldn't fetch location, but should have GPS! The thrown Platform Exception was $e");
      position = Position(
          latitude: 48.796625, longitude: 9.221205); // roughly mway Stuttgart
    }
    response = await http
        .get(
            "https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=7328c736ae7355ac59b28bf4a1ce2d68")
        .timeout(const Duration(milliseconds: 5000));
  }
  if (response.statusCode == 200) {
    return Forecast.fromJson(response.body);
  } else {
    throw Exception(
        "Another than status code 200 was returned. Status code was ${response.statusCode}.");
  }
}
