import 'dart:async';
import 'dart:io';
import 'package:watcher/watcher.dart';
import '../generator/localization_generator.dart';

/// Watches localization files for changes and triggers regeneration
class FileWatcher {
  /// Directory to watch for changes
  final String watchDir;

  /// Debounce duration to prevent multiple rapid regenerations
  final Duration debounceDuration;

  /// Generator instance for regeneration
  final LocalizationGenerator generator;

  /// Completer to control the watch lifecycle
  Completer<void>? _completer;

  /// Timer for debouncing
  Timer? _debounceTimer;

  /// Creates a new FileWatcher instance
  ///
  /// The [watchDir] parameter specifies the directory to watch.
  /// The [debounceDuration] parameter controls the debounce delay.
  /// The [generator] parameter is used to regenerate files on changes.
  ///
  /// Example:
  /// ```dart
  /// final watcher = FileWatcher(
  ///   watchDir: 'assets/localizations',
  ///   debounceDuration: Duration(milliseconds: 300),
  ///   generator: generator,
  /// );
  /// await watcher.start();
  /// ```
  FileWatcher({
    required this.watchDir,
    this.debounceDuration = const Duration(milliseconds: 300),
    required this.generator,
  });

  /// Starts watching the directory for changes
  ///
  /// Returns a [Future] that completes when watching is stopped.
  /// The watcher will continue running until [stop] is called.
  ///
  /// Throws an [Exception] if the watch directory doesn't exist.
  ///
  /// Example:
  /// ```dart
  /// final watcher = FileWatcher(
  ///   watchDir: 'assets/localizations',
  ///   generator: generator,
  /// );
  /// await watcher.start();
  /// ```
  Future<void> start() async {
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

  /// Checks if the event should trigger a regeneration
  bool _shouldProcessEvent(WatchEvent event) {
    // Only process JSON files
    if (!event.path.endsWith('.json')) {
      return false;
    }

    // Process ADD, MODIFY, and REMOVE events
    return event.type == ChangeType.ADD ||
        event.type == ChangeType.MODIFY ||
        event.type == ChangeType.REMOVE;
  }

  /// Handles file changes with debouncing
  void _handleFileChange(WatchEvent event) {
    // Cancel existing timer
    _debounceTimer?.cancel();

    // Create new timer for debounced regeneration
    _debounceTimer = Timer(debounceDuration, () {
      _regenerate(event);
    });
  }

  /// Regenerates localization files
  void _regenerate(WatchEvent event) {
    final eventType = _getEventTypeString(event.type);
    final fileName = event.path.split('/').last;

    print('\n🔄 File $eventType: $fileName');
    print('   Regenerating...');

    try {
      generator.generate();
      print('✅ Regeneration complete\n');
    } catch (e) {
      print('❌ Regeneration failed: $e\n');
    }
  }

  /// Converts ChangeType to readable string
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
