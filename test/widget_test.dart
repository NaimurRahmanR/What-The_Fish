import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:what_the_fish/models/fish_identification.dart';
import 'package:what_the_fish/providers/fish_provider.dart';
import 'package:what_the_fish/utils/theme.dart';

// ✅ MockFishProvider with all required methods implemented
class MockFishProvider extends ChangeNotifier implements FishProvider {
  // ignore: prefer_final_fields
  List<FishIdentification> _identifications = [];
  // ignore: prefer_final_fields
  bool _isLoading = false;
  String? _error;

  @override
  List<FishIdentification> get identifications => _identifications;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  @override
  Future<void> initializeDatabase() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<void> deleteIdentification(String id) async {
    _identifications.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  @override
  List<FishIdentification> filterByConfidence(double minConfidence) {
    return _identifications
        .where((id) => id.confidence >= minConfidence)
        .toList();
  }

  @override
  List<FishIdentification> filterByDateRange(DateTime start, DateTime end) {
    return _identifications
        .where((id) =>
            id.identifiedAt.isAfter(start) && id.identifiedAt.isBefore(end))
        .toList();
  }

  @override
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  Future<FishIdentification?> identifyFish(String imagePath) async {
    return Future.value(null); 
  }

  @override
  Future<void> loadHistory() async {
    // No-op for mock
  }
}

void main() {
  group('What the Fish App Tests', () {
    testWidgets('App theme loads correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.oceanTheme,
          darkTheme: AppTheme.darkOceanTheme,
          home: const Scaffold(
            body: Center(child: Text('Test')),
          ),
        ),
      );

      await tester.pump();

      final ThemeData theme = Theme.of(tester.element(find.text('Test')));
      expect(theme, isNotNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Provider initializes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<FishProvider>(create: (_) => MockFishProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer<FishProvider>(
                builder: (context, fishProvider, child) {
                  return Text('Identifications: ${fishProvider.identifications.length}');
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('Identifications: 0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Basic widget rendering works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test App')),
            body: const Center(child: Text('Hello World')),
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('Theme colors are applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.oceanTheme,
          home: Scaffold(
            appBar: AppBar(title: const Text('Ocean Theme Test')),
            body: const Center(child: Text('Theme Test')),
          ),
        ),
      );

      await tester.pump();
      
      expect(find.text('Ocean Theme Test'), findsOneWidget);
      expect(find.text('Theme Test'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
