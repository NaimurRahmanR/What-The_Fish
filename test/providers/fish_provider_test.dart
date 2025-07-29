import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_fish/providers/fish_provider.dart';
import 'package:what_the_fish/models/fish_identification.dart';

void main() {
  group('FishProvider Tests', () {
    late FishProvider fishProvider;

    setUp(() {
      fishProvider = FishProvider();
    });

    test('should initialize with empty state', () {
      expect(fishProvider.identifications, isEmpty);
      expect(fishProvider.isLoading, isFalse);
      expect(fishProvider.error, isNull);
    });

    test('should filter identifications by confidence', () {
      // Create test data
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

      final mediumConfidenceFish = FishIdentification(
        speciesName: 'Medium Confidence Fish',
        scientificName: 'Mediumus confidencus',
        confidence: 0.7,
        imagePath: '/test3',
        isEdible: true,
      );

      // Manually add to list for testing (normally would come from database)
      fishProvider.identifications.addAll([
        highConfidenceFish,
        lowConfidenceFish,
        mediumConfidenceFish,
      ]);

      // Test filtering with threshold 0.8
      final highFiltered = fishProvider.filterByConfidence(0.8);
      expect(highFiltered.length, equals(1));
      expect(highFiltered.first.speciesName, equals('High Confidence Fish'));

      // Test filtering with threshold 0.5
      final mediumFiltered = fishProvider.filterByConfidence(0.5);
      expect(mediumFiltered.length, equals(2));
      expect(mediumFiltered.any((f) => f.speciesName == 'High Confidence Fish'), isTrue);
      expect(mediumFiltered.any((f) => f.speciesName == 'Medium Confidence Fish'), isTrue);

      // Test filtering with threshold 0.0
      final allFiltered = fishProvider.filterByConfidence(0.0);
      expect(allFiltered.length, equals(3));
    });

    test('should filter identifications by date range', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      final tomorrow = now.add(const Duration(days: 1));

      final recentFish = FishIdentification(
        speciesName: 'Recent Fish',
        scientificName: 'Recentus fishus',
        confidence: 0.8,
        imagePath: '/recent',
        isEdible: true,
        identifiedAt: now,
      );

      final oldFish = FishIdentification(
        speciesName: 'Old Fish',
        scientificName: 'Oldus fishus',
        confidence: 0.9,
        imagePath: '/old',
        isEdible: true,
        identifiedAt: twoDaysAgo,
      );

      // Add to provider
      fishProvider.identifications.addAll([recentFish, oldFish]);

      // Filter by date range (yesterday to tomorrow)
      final filtered = fishProvider.filterByDateRange(yesterday, tomorrow);
      
      expect(filtered.length, equals(1));
      expect(filtered.first.speciesName, equals('Recent Fish'));

      // Filter by wider range
      final widerFiltered = fishProvider.filterByDateRange(
        twoDaysAgo.subtract(const Duration(hours: 1)),
        tomorrow,
      );
      expect(widerFiltered.length, equals(2));
    });

    test('should clear error state', () {
      // Simulate an error by directly setting it
      fishProvider.clearError(); // This should not throw
      expect(fishProvider.error, isNull);
    });

    test('should handle empty identification list', () {
      expect(fishProvider.identifications, isEmpty);
      
      final filtered = fishProvider.filterByConfidence(0.5);
      expect(filtered, isEmpty);
      
      final dateFiltered = fishProvider.filterByDateRange(
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now().add(const Duration(days: 1)),
      );
      expect(dateFiltered, isEmpty);
    });

    test('should maintain loading state properly', () {
      expect(fishProvider.isLoading, isFalse);
      // In a real test, you would test the loading state changes
      // but since we can't easily test async methods here, we just verify initial state
    });
  });
}
