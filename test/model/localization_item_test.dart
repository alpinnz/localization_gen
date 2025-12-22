/// Tests for LocalizationItem and LocaleData models.
///
/// Covers data model functionality.

import 'package:test/test.dart';
import 'package:localization_gen/src/model/localization_item.dart';

void main() {
  group('LocalizationItem', () {
    test('creates with all properties', () {
      final item = LocalizationItem(
        key: 'hello',
        value: 'Hello, {name}!',
        parameters: ['name'],
      );

      expect(item.key, equals('hello'));
      expect(item.value, equals('Hello, {name}!'));
      expect(item.parameters, equals(['name']));
    });

    test('supports pluralization forms', () {
      final item = LocalizationItem(
        key: 'items',
        value: '{count} items',
        parameters: ['count'],
        pluralForms: {
          'zero': 'No items',
          'one': 'One item',
          'other': '{count} items',
        },
      );

      expect(item.pluralForms, isNotNull);
      expect(item.pluralForms?['zero'], equals('No items'));
      expect(item.pluralForms?['one'], equals('One item'));
    });

    test('supports gender forms', () {
      final item = LocalizationItem(
        key: 'greeting',
        value: 'Hello',
        parameters: ['gender', 'name'],
        genderForms: {
          'male': 'Hello Mr. {name}',
          'female': 'Hello Ms. {name}',
          'other': 'Hello {name}',
        },
      );

      expect(item.genderForms, isNotNull);
      expect(item.genderForms?['male'], contains('Mr.'));
    });

    test('supports context forms', () {
      final item = LocalizationItem(
        key: 'invitation',
        value: 'Join us',
        parameters: ['context'],
        contextForms: {
          'formal': 'We cordially invite you',
          'informal': 'Come join us',
        },
      );

      expect(item.contextForms, isNotNull);
      expect(item.contextForms?['formal'], contains('cordially'));
    });
  });

  group('LocaleData', () {
    test('creates with locale and items', () {
      final data = LocaleData(
        locale: 'en',
        items: {
          'hello': LocalizationItem(
            key: 'hello',
            value: 'Hello',
            parameters: [],
          ),
        },
      );

      expect(data.locale, equals('en'));
      expect(data.items.length, equals(1));
      expect(data.items['hello']?.value, equals('Hello'));
    });

    test('supports empty items', () {
      final data = LocaleData(
        locale: 'en',
        items: {},
      );

      expect(data.locale, equals('en'));
      expect(data.items, isEmpty);
    });

    test('allows multiple items', () {
      final data = LocaleData(
        locale: 'en',
        items: {
          'hello': LocalizationItem(
            key: 'hello',
            value: 'Hello',
            parameters: [],
          ),
          'goodbye': LocalizationItem(
            key: 'goodbye',
            value: 'Goodbye',
            parameters: [],
          ),
        },
      );

      expect(data.items.length, equals(2));
      expect(data.items.keys, containsAll(['hello', 'goodbye']));
    });
  });
}
