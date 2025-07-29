import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:what_the_fish/providers/fish_provider.dart';
import 'package:what_the_fish/screens/splash_screen.dart';
import 'package:what_the_fish/utils/theme.dart';

void main() {
  group('What the Fish App Tests', () {
    testWidgets('Splash screen displays correctly', (WidgetTester tester) async {
      // Create a test app with just the splash screen
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.oceanTheme,
          home: const SplashScreen(),
        ),
      );

      // Wait for initial render
      await tester.pump();

      // Verify that splash screen elements are present
      expect(find.text('What the Fish'), findsOneWidget);
      expect(find.text('Discover the Depths'), findsOneWidget);
      expect(find.text('v1.0'), findsOneWidget);
      
      // Verify app doesn't crash on startup
      expect(tester.takeException(), isNull);
    });

    testWidgets('App theme loads correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.oceanTheme,
          home: const Scaffold(
            body: Center(
              child: Text('Test'),
            ),
          ),
        ),
      );
      
      await tester.pump();
      
      // Verify theme is applied
      final ThemeData theme = Theme.of(tester.element(find.text('Test')));
      expect(theme, isNotNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Provider initializes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => FishProvider()),
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
      
      // Verify provider works
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
  });
}
