// To parse this JSON data, do
//
//     final image = imageFromJson(jsonString);

import 'dart:convert';

Gambar imageFromJson(String str) => Gambar.fromJson(json.decode(str));

String imageToJson(Gambar data) => json.encode(data.toJson());

class Gambar {
  int id;
  String image1;
  int catatanId;

  Gambar({
    required this.id,
    required this.image1,
    required this.catatanId,
  });

  factory Gambar.fromJson(Map<String, dynamic> json) => Gambar(
        id: json["id"],
        image1: json["image1"],
        catatanId: json["catatanId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image1": image1,
        "catatanId": catatanId,
      };
}
