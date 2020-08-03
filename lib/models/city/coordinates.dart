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
      lat: map['lat'] * 1.0,
      lon: map['lon'] * 1.0,
    );
  }

  static Coordinates fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'Coordinates(lat: $lat, lon: $lon)';
}
