import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';

import 'package:localization_gen/src/config/config_reader.dart';
import 'package:localization_gen/src/const/constants.dart';
import 'package:localization_gen/src/generator/localization_generator.dart';

/// Watches localization files for changes and triggers regeneration.
///
/// The watch directory is always taken from `pubspec.yaml` via [ConfigReader].
class FileWatcher {
  /// Debounce duration to prevent multiple rapid regenerations.
  final Duration debounceDuration;

  /// Generator instance for regeneration.
  final LocalizationGenerator generator;

  /// Completer to control the watch lifecycle.
  Completer<void>? _completer;

  /// Timer for debouncing.
  Timer? _debounceTimer;

  /// Creates a new FileWatcher instance.
  ///
  /// The watcher always listens to the configured input directory.
  ///
  /// Example:
  /// ```dart
  /// final watcher = FileWatcher(
  ///   debounceDuration: Duration(milliseconds: kWatchDebounceMs),
  ///   generator: generator,
  /// );
  /// await watcher.start();
  /// ```
  FileWatcher({
    this.debounceDuration = const Duration(milliseconds: kWatchDebounceMs),
    required this.generator,
  });

  /// Starts watching the configured input directory for changes.
  ///
  /// Returns a [Future] that completes when watching is stopped.
  /// The watcher will continue running until [stop] is called.
  ///
  /// Throws an [Exception] if the configured watch directory doesn't exist.
  Future<void> start() async {
    final config = ConfigReader.read();
    final watchDir = config.inputDir;

    final dir = Directory(watchDir);
    if (!dir.existsSync()) {
      throw Exception('Watch directory not found: $watchDir');
    }

    _completer = Completer<void>();

    print('👀 Watching for changes in: $watchDir');
    print('   Press Ctrl+C to stop\n');

    final watcher = DirectoryWatcher(watchDir);

    try {
      await for (final event in watcher.events) {
        if (_shouldProcessEvent(event)) {
          _handleFileChange(event);
        }
      }
    } catch (e) {
      print('Watch error: $e');
      if (!_completer!.isCompleted) {
        _completer!.completeError(e);
      }
    }

    return _completer!.future;
  }

  /// Stops the file watcher
  ///
  /// Cancels any pending debounced regenerations and completes the watch future.
  ///
  /// Example:
  /// ```dart
  /// watcher.stop();
  /// ```
  void stop() {
    _debounceTimer?.cancel();
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete();
    }
  }

  /// Checks if a watch event should trigger regeneration.
  ///
  /// The [event] parameter contains the file system event.
  ///
  /// Returns true if the event is for a JSON file and is an ADD, MODIFY,
  /// or REMOVE event.
  bool _shouldProcessEvent(WatchEvent event) {
    final normalizedPath = p.normalize(event.path);
    if (p.extension(normalizedPath).toLowerCase() != '.json') {
      return false;
    }

    return event.type == ChangeType.ADD ||
        event.type == ChangeType.MODIFY ||
        event.type == ChangeType.REMOVE;
  }

  /// Handles file changes with debouncing.
  ///
  /// The [event] parameter contains the file system event.
  ///
  /// Cancels any pending regeneration and schedules a new one after
  /// the debounce duration.
  void _handleFileChange(WatchEvent event) {
    // Cancel existing timer
    _debounceTimer?.cancel();

    // Create new timer for debounced regeneration
    _debounceTimer = Timer(debounceDuration, () {
      _regenerate(event);
    });
  }

  /// Regenerates localization files after a change.
  ///
  /// The [event] parameter contains the file system event that triggered
  /// the regeneration.
  ///
  /// Calls the generator and displays success or error messages.
  void _regenerate(WatchEvent event) {
    final eventType = _getEventTypeString(event.type);
    final fileName = p.basename(p.normalize(event.path));

    print('\n[CHANGE] File $eventType: $fileName');
    print('[REGEN] Regenerating...');

    try {
      generator.generate();
      print('[SUCCESS] Regeneration complete\n');
    } catch (e) {
      print('[ERROR] Regeneration failed: $e\n');
    }
  }

  /// Converts ChangeType to a readable string.
  ///
  /// The [type] parameter is the change type from the watch event.
  ///
  /// Returns a human-readable string describing the change type.
  String _getEventTypeString(ChangeType type) {
    switch (type) {
      case ChangeType.ADD:
        return 'added';
      case ChangeType.MODIFY:
        return 'modified';
      case ChangeType.REMOVE:
        return 'removed';
      default:
        return 'changed';
    }
  }
}
