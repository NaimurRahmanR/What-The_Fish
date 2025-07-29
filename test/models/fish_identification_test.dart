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
    });

    test('should convert to and from JSON correctly', () {
      final originalFish = FishIdentification(
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
      );

      // Convert to JSON
      final json = originalFish.toJson();
      
      // Convert back from JSON
      final reconstructedFish = FishIdentification.fromJson(json);

      // Verify all fields match
      expect(reconstructedFish.speciesName, equals(originalFish.speciesName));
      expect(reconstructedFish.scientificName, equals(originalFish.scientificName));
      expect(reconstructedFish.confidence, equals(originalFish.confidence));
      expect(reconstructedFish.isEdible, equals(originalFish.isEdible));
      expect(reconstructedFish.habitat, equals(originalFish.habitat));
      expect(reconstructedFish.edibilityReason, equals(originalFish.edibilityReason));
    });

    test('should handle null optional fields correctly', () {
      final fish = FishIdentification(
        speciesName: 'Unknown Fish',
        scientificName: 'Unknown sp.',
        confidence: 0.1,
        imagePath: '/path',
        isEdible: false,
      );

      expect(fish.habitat, isNull);
      expect(fish.size, isNull);
      expect(fish.facts, isNull);
      expect(fish.location, isNull);
      expect(fish.edibilityReason, isNull);
      expect(fish.cookingMethods, isNull);
    });
  });

  group('AlternativeFish Model Tests', () {
    test('should create AlternativeFish with required fields', () {
      final altFish = AlternativeFish(
        speciesName: 'Alternative Fish',
        scientificName: 'Alternativus fishus',
        confidence: 0.75,
      );

      expect(altFish.speciesName, equals('Alternative Fish'));
      expect(altFish.scientificName, equals('Alternativus fishus'));
      expect(altFish.confidence, equals(0.75));
    });

    test('should convert to and from JSON correctly', () {
      final originalAlt = AlternativeFish(
        speciesName: 'Angelfish',
        scientificName: 'Pomacanthidae',
        confidence: 0.88,
      );

      final json = originalAlt.toJson();
      final reconstructedAlt = AlternativeFish.fromJson(json);

      expect(reconstructedAlt.speciesName, equals(originalAlt.speciesName));
      expect(reconstructedAlt.scientificName, equals(originalAlt.scientificName));
      expect(reconstructedAlt.confidence, equals(originalAlt.confidence));
    });
  });
}
