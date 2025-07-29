import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_fish/models/fish_identification.dart';

void main() {
  group('FishIdentification Model Tests', () {
    test('should create FishIdentification with required fields', () {
      final fish = FishIdentification(
        speciesName: 'Test Fish',
        scientificName: 'Testus fishus',
        confidence: 0.95,
        imagePath: '/test/path',
        isEdible: true,
      );

      expect(fish.speciesName, equals('Test Fish'));
      expect(fish.scientificName, equals('Testus fishus'));
      expect(fish.confidence, equals(0.95));
      expect(fish.imagePath, equals('/test/path'));
      expect(fish.isEdible, equals(true));
      expect(fish.id, isNotNull);
      expect(fish.identifiedAt, isNotNull);
      expect(fish.alternatives, isEmpty);
    });

    test('should handle optional fields correctly', () {
      final fish = FishIdentification(
        speciesName: 'Clownfish',
        scientificName: 'Amphiprioninae',
        confidence: 0.92,
        imagePath: '/path/to/image',
        isEdible: true,
        habitat: 'Coral reefs',
        size: '2-5 inches',
        facts: 'Can change sex if needed',
        edibilityReason: 'Safe to eat when properly prepared',
        cookingMethods: 'Grilling, frying, steaming',
        alternatives: [
          AlternativeFish(
            speciesName: 'Anemone Fish',
            scientificName: 'Amphiprion sp.',
            confidence: 0.87,
          ),
        ],
      );

      expect(fish.habitat, equals('Coral reefs'));
      expect(fish.size, equals('2-5 inches'));
      expect(fish.facts, equals('Can change sex if needed'));
      expect(fish.edibilityReason, equals('Safe to eat when properly prepared'));
      expect(fish.cookingMethods, equals('Grilling, frying, steaming'));
      expect(fish.alternatives.length, equals(1));
      expect(fish.alternatives.first.speciesName, equals('Anemone Fish'));
    });

    test('should convert to JSON correctly', () {
      final fish = FishIdentification(
        speciesName: 'Test Fish',
        scientificName: 'Testus fishus',
        confidence: 0.85,
        imagePath: '/test/path',
        isEdible: false,
        edibilityReason: 'Contains toxins',
      );

      final json = fish.toJson();

      expect(json['speciesName'], equals('Test Fish'));
      expect(json['scientificName'], equals('Testus fishus'));
      expect(json['confidence'], equals(0.85));
      expect(json['imagePath'], equals('/test/path'));
      expect(json['isEdible'], equals(false));
      expect(json['edibilityReason'], equals('Contains toxins'));
      expect(json['id'], isNotNull);
      expect(json['identifiedAt'], isNotNull);
    });

    test('should create from JSON correctly', () {
      final jsonData = {
        'id': 'test-id-123',
        'speciesName': 'JSON Fish',
        'scientificName': 'JSONus fishus',
        'confidence': 0.75,
        'imagePath': '/json/path',
        'identifiedAt': DateTime.now().toIso8601String(),
        'isEdible': true,
        'habitat': 'Test habitat',
        'alternatives': [],
      };

      final fish = FishIdentification.fromJson(jsonData);

      expect(fish.id, equals('test-id-123'));
      expect(fish.speciesName, equals('JSON Fish'));
      expect(fish.scientificName, equals('JSONus fishus'));
      expect(fish.confidence, equals(0.75));
      expect(fish.imagePath, equals('/json/path'));
      expect(fish.isEdible, equals(true));
      expect(fish.habitat, equals('Test habitat'));
    });

    test('should handle null values in JSON', () {
      final jsonData = {
        'id': 'test-id-456',
        'speciesName': 'Null Fish',
        'scientificName': 'Nullus fishus',
        'confidence': 0.5,
        'imagePath': '/null/path',
        'identifiedAt': DateTime.now().toIso8601String(),
        'isEdible': false,
        'habitat': null,
        'size': null,
        'facts': null,
        'edibilityReason': null,
        'cookingMethods': null,
        'alternatives': [],
      };

      final fish = FishIdentification.fromJson(jsonData);

      expect(fish.habitat, isNull);
      expect(fish.size, isNull);
      expect(fish.facts, isNull);
      expect(fish.edibilityReason, isNull);
      expect(fish.cookingMethods, isNull);
    });
  });

  group('AlternativeFish Model Tests', () {
    test('should create AlternativeFish correctly', () {
      final altFish = AlternativeFish(
        speciesName: 'Alternative Fish',
        scientificName: 'Alternativus fishus',
        confidence: 0.75,
      );

      expect(altFish.speciesName, equals('Alternative Fish'));
      expect(altFish.scientificName, equals('Alternativus fishus'));
      expect(altFish.confidence, equals(0.75));
    });

    test('should convert AlternativeFish to JSON', () {
      final altFish = AlternativeFish(
        speciesName: 'Test Alt',
        scientificName: 'Testus alternativus',
        confidence: 0.88,
      );

      final json = altFish.toJson();

      expect(json['speciesName'], equals('Test Alt'));
      expect(json['scientificName'], equals('Testus alternativus'));
      expect(json['confidence'], equals(0.88));
    });

    test('should create AlternativeFish from JSON', () {
      final jsonData = {
        'speciesName': 'JSON Alt',
        'scientificName': 'JSONus alternativus',
        'confidence': 0.65,
      };

      final altFish = AlternativeFish.fromJson(jsonData);

      expect(altFish.speciesName, equals('JSON Alt'));
      expect(altFish.scientificName, equals('JSONus alternativus'));
      expect(altFish.confidence, equals(0.65));
    });
  });
}
