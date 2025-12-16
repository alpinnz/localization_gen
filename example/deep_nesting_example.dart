import 'dart:io';
import 'package:localization_gen/src/parser/json_parser.dart';
import 'package:localization_gen/src/writer/dart_writer.dart';

/// Example demonstrating 10 levels of nested JSON localization
void main() {
  print('=== 10-Level Nested JSON Localization Example ===\n');

  // Create test files with 10 levels of nesting
  final enFile = File('example_10_levels_en.json');
  final idFile = File('example_10_levels_id.json');

  // English localization with 10 levels
  enFile.writeAsStringSync('''
{
  "@@locale": "en",
  "level1": {
    "level2": {
      "level3": {
        "level4": {
          "level5": {
            "level6": {
              "level7": {
                "level8": {
                  "level9": {
                    "level10": {
                      "deepValue": "This is deeply nested value",
                      "greeting": "Hello from level 10!",
                      "message": "You reached the deepest level with {count} steps"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "app": {
    "settings": {
      "profile": {
        "personal": {
          "info": {
            "contact": {
              "phone": {
                "mobile": {
                  "primary": {
                    "number": "Primary Phone Number",
                    "label": "Your primary mobile number"
                  },
                  "secondary": {
                    "number": "Secondary Phone Number"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
''');

  // Indonesian localization with 10 levels
  idFile.writeAsStringSync('''
{
  "@@locale": "id",
  "level1": {
    "level2": {
      "level3": {
        "level4": {
          "level5": {
            "level6": {
              "level7": {
                "level8": {
                  "level9": {
                    "level10": {
                      "deepValue": "Ini adalah nilai yang sangat dalam",
                      "greeting": "Halo dari level 10!",
                      "message": "Anda mencapai level terdalam dengan {count} langkah"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  "app": {
    "settings": {
      "profile": {
        "personal": {
          "info": {
            "contact": {
              "phone": {
                "mobile": {
                  "primary": {
                    "number": "Nomor Telepon Utama",
                    "label": "Nomor telepon utama Anda"
                  },
                  "secondary": {
                    "number": "Nomor Telepon Kedua"
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
''');

  print('Created example JSON files:');
  print('  - ${enFile.path}');
  print('  - ${idFile.path}\n');

  // Parse the JSON files
  print('Parsing JSON files...');
  final enData = JsonLocalizationParser.parse(enFile);
  final idData = JsonLocalizationParser.parse(idFile);

  print('Parsed ${enData.items.length} English translations');
  print('Parsed ${idData.items.length} Indonesian translations\n');

  // Show some parsed keys
  print('Example parsed keys:');
  enData.items.keys.take(5).forEach((key) {
    print('  - $key');
  });
  print('  ...\n');

  // Generate Dart code
  print('Generating Dart code...');
  final writer = DartWriter(
    className: 'DeepLocalizations',
    useContext: true,
    nullable: false,
  );

  final code = writer.generate([enData, idData]);

  // Save generated code
  final outputFile = File('deep_localizations.dart');
  outputFile.writeAsStringSync(code);

  print('Generated: ${outputFile.path}\n');

  // Show usage example
  print('=== Usage Example ===\n');
  print('// Access deeply nested translations:');
  print('final l10n = DeepLocalizations.of(context);');
  print('');
  print('// Level 10 access:');
  print(
      'print(l10n.level1.level2.level3.level4.level5.level6.level7.level8.level9.level10.greeting);');
  print('// Output: "Hello from level 10!"');
  print('');
  print('// With parameters:');
  print(
      'print(l10n.level1.level2.level3.level4.level5.level6.level7.level8.level9.level10.message(count: "10"));');
  print('// Output: "You reached the deepest level with 10 steps"');
  print('');
  print('// Another deep path:');
  print(
      'print(l10n.app.settings.profile.personal.info.contact.phone.mobile.primary.number);');
  print('// Output: "Primary Phone Number"');
  print('');

  print('\n=== Generated Classes ===\n');
  print('The generator created the following nested class hierarchy:');
  print('  DeepLocalizations');
  print('    └─ _Level1');
  print('       └─ _Level1_Level2');
  print('          └─ _Level1_Level2_Level3');
  print('             └─ _Level1_Level2_Level3_Level4');
  print('                └─ _Level1_Level2_Level3_Level4_Level5');
  print('                   └─ _Level1_Level2_Level3_Level4_Level5_Level6');
  print(
      '                      └─ _Level1_Level2_Level3_Level4_Level5_Level6_Level7');
  print(
      '                         └─ _Level1_Level2_Level3_Level4_Level5_Level6_Level7_Level8');
  print(
      '                            └─ _Level1_Level2_Level3_Level4_Level5_Level6_Level7_Level8_Level9');
  print(
      '                               └─ _Level1_Level2_Level3_Level4_Level5_Level6_Level7_Level8_Level9_Level10');
  print('');
  print('Each class provides type-safe access to its nested translations!');
  print('\nDone! ✓');
}
