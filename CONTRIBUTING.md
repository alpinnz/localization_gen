# Contributing Guide

Repository: https://github.com/alpinnz/localization_gen

## Quick Start

```bash
git clone https://github.com/YOUR_USERNAME/localization_gen.git
cd localization_gen

dart pub get

dart format .
dart analyze
dart test
```

## Development Standards

### Code Style

Follow Dart conventions and prefer clear variable names.

### Documentation

All public APIs should be documented with examples when helpful.

### Testing

- Add tests for new behavior and edge cases.
- Prefer fast unit tests.

## Pull Request Checklist

- Code is formatted (`dart format .`)
- No analyzer issues (`dart analyze`)
- Tests pass (`dart test`)
- Documentation updated when behavior or configuration changes
- `CHANGELOG.md` updated for user-facing changes

## Release Process

Maintainers handle releases:

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Tag the release
4. Publish to pub.dev

## Help

- Issues: https://github.com/alpinnz/localization_gen/issues
- Discussions: https://github.com/alpinnz/localization_gen/discussions

## License

By contributing, you agree your contributions will be licensed under the MIT License.
