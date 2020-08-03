import 'package:http/http.dart' as http;
import 'package:weather_app/models/wheather/current_and_daily_weather.dart';

Future<CurrentAndDailyWeather> fetchCurrentAndDailyWeather(
    double lat, double lon) async {
  http.Response response;
  response = await http.get(
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&exclude={minutely,hourly}&appid=7328c736ae7355ac59b28bf4a1ce2d68");
  if (response.statusCode == 200) {
    return CurrentAndDailyWeather.fromJson(response.body);
  } else {
    throw Exception(
        "Another than status code 200 was returned. Status code was ${response.statusCode}.");
  }
}
