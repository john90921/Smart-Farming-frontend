// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';
import 'dart:ffi';


class Plant {
final int? id;
 final String? image;
 final int? diseaseId;
 final double? confidence;
final DateTime created_at;


  Plant({
  required this.id,
    required this.image,
    required this.diseaseId,
    required this.confidence,
    required this.created_at,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': image,
      'diseaseId': diseaseId,
      'confidence': confidence,
      'created_at': created_at.toUtc().toIso8601String(),
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as int?,
      image: map['image'] as String?,
      diseaseId: map['diseaseId'] as int?,
      confidence: double.parse(map['confidence'] as String),
      created_at: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Plant.fromJson(String source) => Plant.fromMap(json.decode(source) as Map<String, dynamic>);
}
