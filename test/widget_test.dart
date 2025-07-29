import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:what_the_fish/providers/fish_provider.dart';
import 'package:what_the_fish/screens/splash_screen.dart';
import 'package:what_the_fish/utils/theme.dart';

class MockFishProvider extends ChangeNotifier implements FishProvider {
  @override
  Future<void> initializeDatabase() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Add additional mock stubs if needed
}

void main() {
  group('What the Fish App Tests', () {
    testWidgets('App loads and shows splash screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.oceanTheme,
          darkTheme: AppTheme.darkOceanTheme,
          home: ChangeNotifierProvider<FishProvider>.value(
            value: MockFishProvider(),
            child: const SplashScreen(),
          ),
        ),
      );

      // Allow animations and splash screen delay
      await tester.pump(); // start animations
      await tester.pump(const Duration(seconds: 1)); // animation
      await tester.pump(const Duration(seconds: 3)); // splash delay
      await tester.pumpAndSettle(); // settle any navigation

      expect(find.text('What the Fish'), findsOneWidget);
      expect(find.text('Discover the Depths'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('App initializes without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.oceanTheme,
          darkTheme: AppTheme.darkOceanTheme,
          home: ChangeNotifierProvider<FishProvider>.value(
            value: MockFishProvider(),
            child: const SplashScreen(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });
}
