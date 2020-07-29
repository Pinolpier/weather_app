import 'dart:convert';

import 'package:weather_app/models/city/coordinates.dart';

class City {
  int id;
  String name;
  String country;
  Coordinates coord;
  City({
    this.id,
    this.name,
    this.country,
    this.coord,
  });

  static City fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return City(
      id: map['id'],
      name: map['name'],
      country: map['country'],
      coord: Coordinates.fromMap(map['coord']),
    );
  }

  static City fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'City(id: $id, name: $name, country: $country, coord: $coord)';
  }
}
