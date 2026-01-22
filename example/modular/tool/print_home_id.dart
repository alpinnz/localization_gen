import 'dart:convert';
import 'dart:io';

void main() {
  final f = File('assets/localizations/app_home_id.json');
  final m = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  for (final k in ['welcome', 'welcome_user', 'item_count', 'discount']) {
    stdout.writeln('$k: ${m[k]}');
  }
}
