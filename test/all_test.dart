/// Main test file - imports all test suites.
///
/// Run with: dart test

library;

// Import all test files
import 'config/config_reader_test.dart' as config_reader_test;
import 'exceptions/exceptions_test.dart' as exceptions_test;
import 'generator/localization_generator_test.dart' as generator_test;
import 'model/localization_item_test.dart' as model_test;
import 'model/field_rename_test.dart' as field_rename_test;
import 'parser/json_parser_test.dart' as parser_test;
import 'parser/validation_test.dart' as validation_test;
import 'watcher/file_watcher_test.dart' as watcher_test;
import 'writer/dart_writer_test.dart' as writer_test;

void main() {
  // Config tests
  config_reader_test.main();

  // Exception tests
  exceptions_test.main();

  // Generator tests
  generator_test.main();

  // Model tests
  model_test.main();
  field_rename_test.main();

  // Parser tests
  parser_test.main();
  validation_test.main();

  // Watcher tests
  watcher_test.main();

  // Writer tests
  writer_test.main();
}
