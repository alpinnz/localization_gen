import 'dart:convert';
import 'dart:io';

void main() {
  final f = File('assets/localizations/app_common_id.json');
  final m = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

  final placeholders = (m['placeholders'] as Map<String, dynamic>);
  for (final k in ['welcome_user', 'attempts_left', 'remaining_time']) {
    stdout.writeln('$k: ${placeholders[k]}');
  }
}
