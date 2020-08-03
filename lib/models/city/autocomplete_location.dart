import 'dart:convert';

class WeatherServiceLocation {
  int id;
  String name;
  String country;
  String state;
  WeatherServiceLocation(this.id, this.name, this.country, {this.state});

  String toUiString() {
    return '$name, ' +
        ((state != null && state.isNotEmpty) ? (state + ", ") : "") +
        '$country';
  }

  static WeatherServiceLocation fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WeatherServiceLocation(map['id'], map['name'], map['country'],
        state: map['state']);
  }

  static WeatherServiceLocation fromJson(String source) =>
      fromMap(json.decode(source));
}

class WeatherServiceLocationList {
  List<WeatherServiceLocation> allLocations;
  WeatherServiceLocationList(this.allLocations);

  static WeatherServiceLocationList fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return WeatherServiceLocationList(
      List<WeatherServiceLocation>.from(
          map['allLocations']?.map((x) => WeatherServiceLocation.fromMap(x))),
    );
  }

  static WeatherServiceLocationList fromJsonList(List<dynamic> jsonList) {
    List<WeatherServiceLocation> allLocations = [];
    for (dynamic i in jsonList) {
      allLocations.add(WeatherServiceLocation(i["id"], i["name"], i["country"],
          state: i["state"]));
    }
    return WeatherServiceLocationList(allLocations);
  }

  static WeatherServiceLocationList fromJson(String source) =>
      fromJsonList(json.decode(source));
}
