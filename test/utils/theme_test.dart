import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:what_the_fish/utils/theme.dart';

void main() {
  group('AppTheme Tests', () {
    test('should have ocean theme colors defined', () {
      expect(AppTheme.primaryBlue, equals(const Color(0xFF006994)));
      expect(AppTheme.lightBlue, equals(const Color(0xFF4FC3F7)));
      expect(AppTheme.darkBlue, equals(const Color(0xFF003B57)));
      expect(AppTheme.teal, equals(const Color(0xFF26A69A)));
      expect(AppTheme.aqua, equals(const Color(0xFF00BCD4)));
    });

    test('should create ocean theme without errors', () {
      final theme = AppTheme.oceanTheme;

      expect(theme, isNotNull);
      expect(theme.useMaterial3, isTrue);
      expect(theme.textTheme.bodyMedium?.fontFamily, equals('Roboto'));
    });

    test('should create dark ocean theme without errors', () {
      final darkTheme = AppTheme.darkOceanTheme;

      expect(darkTheme, isNotNull);
      expect(darkTheme.useMaterial3, isTrue);
      expect(darkTheme.textTheme.bodyMedium?.fontFamily, equals('Roboto'));
    });

    test('should have ocean gradient defined', () {
      expect(AppTheme.oceanGradient, isNotNull);
      expect(AppTheme.oceanGradient.begin, equals(Alignment.topCenter));
      expect(AppTheme.oceanGradient.end, equals(Alignment.bottomCenter));
      expect(AppTheme.oceanGradient.colors.length, equals(3));
    });

    test('should have dark ocean gradient defined', () {
      expect(AppTheme.darkOceanGradient, isNotNull);
      expect(AppTheme.darkOceanGradient.begin, equals(Alignment.topCenter));
      expect(AppTheme.darkOceanGradient.end, equals(Alignment.bottomCenter));
      expect(AppTheme.darkOceanGradient.colors.length, equals(3));
    });
  });
}
