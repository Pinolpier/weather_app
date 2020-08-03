import 'package:flutter/services.dart';
import 'package:weather_app/models/city/autocomplete_location.dart';

WeatherServiceLocationList list;

Future<List<WeatherServiceLocation>> complete(String beginning) async {
  beginning = beginning.toLowerCase();
  if (list == null || list.allLocations.isEmpty) {
    await loadCities();
    print("load citites done!");
  }
  List<WeatherServiceLocation> possibilities = [];
  for (WeatherServiceLocation i in list.allLocations) {
    if (i.name.toLowerCase().contains(beginning)) {
      possibilities.add(i);
    }
  }
  return possibilities;
}

Future<void> loadCities() async {
  list = WeatherServiceLocationList.fromJson(await _loadFromAssets());
  print("loaded cities, now returning");
  return;
}

Future<String> _loadFromAssets() async {
  return await rootBundle.loadString("assets/city.list.json");
}
