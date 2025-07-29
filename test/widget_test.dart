import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_fish/main.dart';

void main() {
  group('What the Fish App Tests', () {
    testWidgets('App loads and shows splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const WhatTheFishApp());

      // Verify that splash screen elements are present
      expect(find.text('What the Fish'), findsOneWidget);
      expect(find.text('Discover the Depths'), findsOneWidget);
      
      // Verify app doesn't crash on startup
      expect(tester.takeException(), isNull);
    });

    testWidgets('App initializes without errors', (WidgetTester tester) async {
      await tester.pumpWidget(const WhatTheFishApp());
      
      // Let splash screen animations complete
      await tester.pump(const Duration(seconds: 1));
      
      // Verify no exceptions thrown during initialization
      expect(tester.takeException(), isNull);
    });
  });
}
