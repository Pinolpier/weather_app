import 'package:http/http.dart' as http;
import 'package:weather_app/models/wheather/forecast_element.dart';

Future<ForecastElement> fetchCurrentWeather(int cityId) async {
  final http.Response response = await http.get(
      "https://api.openweathermap.org/data/2.5/weather?id=${cityId}&units=metric&appid=7328c736ae7355ac59b28bf4a1ce2d68");
  if (response.statusCode == 200) {
    return ForecastElement.fromJson(response.body);
  } else {
    throw Exception(
        "Another than status code 200 was returned. Status code was ${response.statusCode}.");
  }
}
