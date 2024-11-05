// To parse this JSON data, do
//
//     final catatan = catatanFromJson(jsonString);

import 'dart:convert';

Catatan catatanFromJson(String str) => Catatan.fromJson(json.decode(str));

String catatanToJson(Catatan data) => json.encode(data.toJson());

class Catatan {
  int id;
  String name;
  int author;
  String description;

  Catatan({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
  });

  factory Catatan.fromJson(Map<String, dynamic> json) => Catatan(
        id: json["id"],
        name: json["name"],
        author: json["author"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "author": author,
        "description": description,
      };
}
