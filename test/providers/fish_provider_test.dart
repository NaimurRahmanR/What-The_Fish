import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_fish/providers/fish_provider.dart';
import 'package:what_the_fish/models/fish_identification.dart';

void main() {
  group('FishProvider Tests', () {
    late FishProvider fishProvider;

    setUp(() {
      fishProvider = FishProvider();
    });

    test('should initialize with empty identifications', () {
      expect(fishProvider.identifications, isEmpty);
      expect(fishProvider.isLoading, isFalse);
      expect(fishProvider.error, isNull);
    });

    test('should filter identifications by confidence', () {
      // Add test identifications
      final highConfidenceFish = FishIdentification(
        speciesName: 'High Confidence Fish',
        scientificName: 'Highus confidencus',
        confidence: 0.95,
        imagePath: '/test1',
        isEdible: true,
      );

      final lowConfidenceFish = FishIdentification(
        speciesName: 'Low Confidence Fish',
        scientificName: 'Lowus confidencus',
        confidence: 0.3,
        imagePath: '/test2',
        isEdible: false,
      );

      // Add to provider's internal list (this would normally be done through database)
      fishProvider.identifications.addAll([highConfidenceFish, lowConfidenceFish]);

      // Test filtering
      final filtered = fishProvider.filterByConfidence(0.8);
      
      expect(filtered.length, equals(1));
      expect(filtered.first.speciesName, equals('High Confidence Fish'));
    });

    test('should filter identifications by date range', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final tomorrow = now.add(const Duration(days: 1));

      final recentFish = FishIdentification(
        speciesName: 'Recent Fish',
        scientificName: 'Recentus fishus',
        confidence: 0.8,
        imagePath: '/recent',
        isEdible: true,
        identifiedAt: now,
      );

      // Add to provider's internal list
      fishProvider.identifications.add(recentFish);

      // Test date filtering
      final filtered = fishProvider.filterByDateRange(yesterday, tomorrow);
      
      expect(filtered.length, equals(1));
      expect(filtered.first.speciesName, equals('Recent Fish'));
    });

    test('should clear error state', () {
      // Set an error
      fishProvider.clearError();
      
      expect(fishProvider.error, isNull);
    });
  });
}
