# Migration Guide v1.0.3 to v1.0.4

This guide helps you migrate from v1.0.3 (positional parameters) to v1.0.4 (named parameters with required keyword).

## Overview

Version 1.0.4 introduces **named parameters with `required` keyword** for all methods with parameters.

## What Changed

### Before (v1.0.3 and earlier)
```dart
// Positional parameters
String welcome_user(String name) {
  // ...
}

// Usage
l10n.welcome_user('John')
l10n.item_count('5')
l10n.discount('20')
```

### After (v1.0.4)
```dart
// Named parameters with required keyword
String welcome_user({required String name}) {
  // ...
}

// Usage
l10n.welcome_user(name: 'John')
l10n.item_count(count: '5')
l10n.discount(value: '20')
```

## Migration Steps

### Step 1: Update Package Version

Update your `pubspec.yaml`:

```yaml
dev_dependencies:
  localization_gen: ^1.0.4
```

Run:
```bash
flutter pub get
```

### Step 2: Regenerate Localization Files

```bash
dart run localization_gen:localization_gen
```

This will regenerate your localization files with the new named parameter syntax.

### Step 3: Update Your Code

The Dart analyzer will help you find all locations that need updating. Look for errors like:

```
Too many positional arguments: 0 expected, but 1 found.
The named parameter 'name' is required, but there's no corresponding argument.
```

#### Example Migrations

**Simple parameter:**
```dart
// Before
final greeting = l10n.welcome_user('John');

// After
final greeting = l10n.welcome_user(name: 'John');
```

**Multiple parameters:**
```dart
// Before
final message = l10n.order_summary('5', '100');

// After
final message = l10n.order_summary(count: '5', total: '100');
```

**In Text widgets:**
```dart
// Before
Text(l10n.discount('25'))

// After  
Text(l10n.discount(value: '25'))
```

**Dynamic values:**
```dart
// Before
Text(l10n.item_count('$_counter'))

// After
Text(l10n.item_count(count: '$_counter'))
```

#### Find and Replace

You can use your IDE's find and replace feature to help:

**Find pattern:** `l10n\.(\w+)\('([^']+)'\)`  
**Replace with:** `l10n.$1(paramName: '$2')`

**Important:** Replace `paramName` with the actual parameter name from your JSON!

### Step 4: Test Your Application

1. **Run analyzer:**
   ```bash
   flutter analyze
   ```
   Fix any remaining errors.

2. **Run your tests:**
   ```bash
   flutter test
   ```
   Update test code if needed.

3. **Manual testing:**
   - Test all screens with localized text
   - Verify parameter interpolation works correctly
   - Test language switching if applicable

## Benefits of This Change

### 1. Better Code Clarity
```dart
// Before - unclear what the parameter is
l10n.greeting('John', 'morning', '5')

// After - crystal clear
l10n.greeting(name: 'John', time: 'morning', count: '5')
```

### 2. Prevention of Parameter Order Mistakes
```dart
// Before - easy to swap parameters
l10n.order_info('100', '5')  // Is this price, quantity or quantity, price?

// After - impossible to make order mistakes
l10n.order_info(price: '100', quantity: '5')
```

### 3. Better IDE Support
- Improved autocomplete with parameter names
- Better documentation tooltips
- Easier refactoring

### 4. Future-Proof
- Parameter order can change without breaking calls
- Adding new parameters won't break existing code

## Common Issues and Solutions

### Issue 1: "Too many positional arguments"

**Error:**
```
Too many positional arguments: 0 expected, but 1 found.
```

**Solution:**
You're still using positional parameters. Change to named:
```dart
// Wrong
l10n.method('value')

// Correct
l10n.method(paramName: 'value')
```

### Issue 2: "The named parameter is required"

**Error:**
```
The named parameter 'name' is required, but there's no corresponding argument.
```

**Solution:**
You forgot to provide the parameter:
```dart
// Wrong
l10n.welcome_user()

// Correct
l10n.welcome_user(name: 'John')
```

### Issue 3: "Undefined named parameter"

**Error:**
```
The named parameter 'wrongName' isn't defined.
```

**Solution:**
Check your JSON file for the correct parameter name:
```json
{
  "welcome": "Hello, {userName}!"
}
```

```dart
// Wrong
l10n.welcome(name: 'John')

// Correct (matches {userName} in JSON)
l10n.welcome(userName: 'John')
```

## Rollback Option

If you need to temporarily rollback:

```yaml
dev_dependencies:
  localization_gen: 1.0.3  # Pin to older version
```

Then regenerate:
```bash
dart run localization_gen:localization_gen
```

**Note:** This is only a temporary solution. We recommend migrating to v1.0.4 for better code quality.

## Need Help?

- Open an issue on [GitHub](https://github.com/alpinnz/localization_gen/issues)
- Read the [main documentation](https://github.com/alpinnz/localization_gen#readme)
- Check the [examples directory](https://github.com/alpinnz/localization_gen/tree/master/example) for updated code
- Read the [complete update guide](https://github.com/alpinnz/localization_gen/blob/master/UPDATE_V1.0.4.md)

## Timeline

- **v1.0.3 and earlier:** Positional parameters
- **v1.0.4+:** Named parameters with `required` keyword
- **Future versions:** Will continue to use named parameters

This is a one-time migration. Future versions will maintain backward compatibility with the named parameter syntax.

