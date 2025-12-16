#!/usr/bin/env dart

import 'package:localization_gen/src/command/generate_command.dart';

Future<void> main(List<String> args) async {
  await GenerateCommand().run(args);
}
