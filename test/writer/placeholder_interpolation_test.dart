import 'package:localization_gen/src/model/localization_item.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';
import 'package:test/test.dart';

void main() {
  test('Interpolates {param} placeholders into valid Dart interpolation', () {
    final writer = DartWriter(className: 'AppLocalizations');

    final locales = [
      LocaleData(
        locale: 'en',
        items: {
          'passwordMismatch': LocalizationItem(
            key: 'passwordMismatch',
            value:
                'Your password doesn’t match yet. You still have {attempts} more tries within 15 minutes.',
            parameters: const ['attempts'],
          ),
        },
      ),
    ];

    final code = writer.generate(locales);

    // Should generate a method with a required String attempts parameter.
    expect(code, contains('required String attempts'));

    // Template stays as `{attempts}` in translation table, and formatting happens at runtime.
    expect(
      code,
      contains(
        "'Your password doesn’t match yet. You still have {attempts} more tries within 15 minutes.'",
      ),
    );
    expect(
      code,
      contains(
          'return _root._tf("passwordMismatch", {\'attempts\': attempts});'),
    );

    // Dollar escaping shouldn't accidentally appear for params.
    expect(code, isNot(contains(r'\\$attempts')));
  });
}
