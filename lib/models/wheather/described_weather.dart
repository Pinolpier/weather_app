import 'dart:convert';

class DescribedWheather {
  int id;
  String iconId;
  String heading;
  String description;
  DescribedWheather({
    this.id,
    this.iconId,
    this.heading,
    this.description,
  });

  static DescribedWheather fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DescribedWheather(
      id: map['id'],
      iconId: map['icon'],
      heading: map['main'],
      description: map['description'],
    );
  }

  static DescribedWheather fromJson(String source) =>
      fromMap(json.decode(source));
}
