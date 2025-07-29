import 'package:hive/hive.dart';

import 'package:uuid/uuid.dart';

part 'fish_identification.g.dart';

@HiveType(typeId: 0)

class FishIdentification extends HiveObject {

@HiveField(0)

String id;

@HiveField(1)

String speciesName;

@HiveField(2)

String scientificName;

@HiveField(3)

double confidence;

@HiveField(4)

String imagePath;

@HiveField(5)

DateTime identifiedAt;

@HiveField(6)

String? location;

@HiveField(7)

String? habitat;

@HiveField(8)

String? size;

@HiveField(9)

String? facts;

@HiveField(10)

List<AlternativeFish> alternatives;

@HiveField(11)

bool isEdible;

@HiveField(12)

String? edibilityReason;

@HiveField(13)

String? cookingMethods;

FishIdentification({

String? id,

required this.speciesName,

required this.scientificName,

required this.confidence,

required this.imagePath,

DateTime? identifiedAt,

this.location,

this.habitat,

this.size,

this.facts,

List<AlternativeFish>? alternatives,

required this.isEdible,

this.edibilityReason,

this.cookingMethods,

}) : id = id ?? const Uuid().v4(),

identifiedAt = identifiedAt ?? DateTime.now(),

alternatives = alternatives ?? [];

Map<String, dynamic> toJson() {

return {

'id': id,

'speciesName': speciesName,

'scientificName': scientificName,

'confidence': confidence,

'imagePath': imagePath,

'identifiedAt': identifiedAt.toIso8601String(),

'location': location,

'habitat': habitat,

'size': size,

'facts': facts,

'alternatives': alternatives.map((a) => a.toJson()).toList(),

'isEdible': isEdible,

'edibilityReason': edibilityReason,

'cookingMethods': cookingMethods,

};

}

factory FishIdentification.fromJson(Map<String, dynamic> json) {

return FishIdentification(

id: json['id'],

speciesName: json['speciesName'],

scientificName: json['scientificName'],

confidence: json['confidence'].toDouble(),

imagePath: json['imagePath'],

identifiedAt: DateTime.parse(json['identifiedAt']),

location: json['location'],

habitat: json['habitat'],

size: json['size'],

facts: json['facts'],

alternatives: (json['alternatives'] as List<dynamic>?)

?.map((a) => AlternativeFish.fromJson(a))

.toList() ?? [],

isEdible: json['isEdible'] ?? false,

edibilityReason: json['edibilityReason'],

cookingMethods: json['cookingMethods'],

);

}

}

@HiveType(typeId: 1)

class AlternativeFish extends HiveObject {

@HiveField(0)

String speciesName;

@HiveField(1)

String scientificName;

@HiveField(2)

double confidence;

AlternativeFish({

required this.speciesName,

required this.scientificName,

required this.confidence,

});

Map<String, dynamic> toJson() {

return {

'speciesName': speciesName,

'scientificName': scientificName,

'confidence': confidence,

};

}

factory AlternativeFish.fromJson(Map<String, dynamic> json) {

return AlternativeFish(

speciesName: json['speciesName'],

scientificName: json['scientificName'],

confidence: json['confidence'].toDouble(),

);

}

}

