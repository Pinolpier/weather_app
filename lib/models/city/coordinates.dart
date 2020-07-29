import 'dart:convert';

class Coordinates {
  double lat;
  double lon;
  Coordinates({
    this.lat,
    this.lon,
  });

  static Coordinates fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Coordinates(
      lat: map['lat'],
      lon: map['lon'],
    );
  }

  static Coordinates fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Coordinates(lat: $lat, lon: $lon)';
}
