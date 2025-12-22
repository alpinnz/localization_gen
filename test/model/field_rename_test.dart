/// Tests for FieldRename enum.
///
/// Covers field naming convention conversions.

import 'package:test/test.dart';
import 'package:localization_gen/src/model/field_rename.dart';

void main() {
  group('FieldRename', () {
    group('convert()', () {
      test('none - keeps original', () {
        expect(FieldRename.none.convert('userName'), equals('userName'));
        expect(FieldRename.none.convert('UserName'), equals('UserName'));
      });

      test('kebab - converts to kebab-case', () {
        expect(FieldRename.kebab.convert('userName'), equals('user-name'));
        expect(FieldRename.kebab.convert('UserName'), equals('-user-name'));
        expect(FieldRename.kebab.convert('user'), equals('user'));
      });

      test('snake - converts to snake_case', () {
        expect(FieldRename.snake.convert('userName'), equals('user_name'));
        expect(FieldRename.snake.convert('UserName'), equals('_user_name'));
        expect(FieldRename.snake.convert('user'), equals('user'));
      });

      test('pascal - converts to PascalCase', () {
        expect(FieldRename.pascal.convert('userName'), equals('UserName'));
        expect(FieldRename.pascal.convert('username'), equals('Username'));
        expect(FieldRename.pascal.convert('UserName'), equals('UserName'));
      });

      test('camel - converts to camelCase', () {
        expect(FieldRename.camel.convert('UserName'), equals('userName'));
        expect(FieldRename.camel.convert('userName'), equals('userName'));
        expect(FieldRename.camel.convert('USERNAME'), equals('uSERNAME'));
      });

      test('screamingSnake - converts to SCREAMING_SNAKE_CASE', () {
        expect(FieldRename.screamingSnake.convert('userName'),
            equals('USER_NAME'));
        expect(FieldRename.screamingSnake.convert('UserName'),
            equals('USER_NAME'));
        expect(FieldRename.screamingSnake.convert('user'), equals('USER'));
      });
    });

    group('fromString()', () {
      test('parses kebab variants', () {
        expect(FieldRename.fromString('kebab'), equals(FieldRename.kebab));
        expect(FieldRename.fromString('kebab-case'), equals(FieldRename.kebab));
        expect(FieldRename.fromString('KEBAB'), equals(FieldRename.kebab));
      });

      test('parses snake variants', () {
        expect(FieldRename.fromString('snake'), equals(FieldRename.snake));
        expect(FieldRename.fromString('snake_case'), equals(FieldRename.snake));
        expect(FieldRename.fromString('SNAKE'), equals(FieldRename.snake));
      });

      test('parses pascal variants', () {
        expect(FieldRename.fromString('pascal'), equals(FieldRename.pascal));
        expect(
            FieldRename.fromString('pascalcase'), equals(FieldRename.pascal));
        expect(FieldRename.fromString('PASCAL'), equals(FieldRename.pascal));
      });

      test('parses camel variants', () {
        expect(FieldRename.fromString('camel'), equals(FieldRename.camel));
        expect(FieldRename.fromString('camelcase'), equals(FieldRename.camel));
        expect(FieldRename.fromString('CAMEL'), equals(FieldRename.camel));
      });

      test('parses screaming_snake variants', () {
        expect(FieldRename.fromString('screaming_snake'),
            equals(FieldRename.screamingSnake));
        expect(FieldRename.fromString('screamingsnake'),
            equals(FieldRename.screamingSnake));
        expect(FieldRename.fromString('screaming-snake'),
            equals(FieldRename.screamingSnake));
      });

      test('returns none for invalid input', () {
        expect(FieldRename.fromString('invalid'), equals(FieldRename.none));
        expect(FieldRename.fromString(''), equals(FieldRename.none));
        expect(FieldRename.fromString('unknown'), equals(FieldRename.none));
      });
    });

    group('Edge Cases', () {
      test('handles empty string', () {
        expect(FieldRename.none.convert(''), equals(''));
        expect(FieldRename.snake.convert(''), equals(''));
        expect(FieldRename.kebab.convert(''), equals(''));
      });

      test('handles single character', () {
        expect(FieldRename.snake.convert('a'), equals('a'));
        expect(FieldRename.kebab.convert('a'), equals('a'));
        expect(FieldRename.pascal.convert('a'), equals('A'));
      });

      test('handles already converted strings', () {
        expect(FieldRename.snake.convert('user_name'), equals('user_name'));
        expect(FieldRename.kebab.convert('user-name'), equals('user-name'));
      });
    });
  });
}
