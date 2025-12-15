# Update Documentation for v1.0.4

## Overview

Version 1.0.4 improves the API for parameter interpolation by introducing **named parameters with the `required` keyword**. This change enhances code clarity, prevents parameter order mistakes, and provides better IDE support.

## What's New in v1.0.4

### Named Parameters with Required Keyword

All methods with parameters now use named parameters instead of positional parameters.

**Before (v1.0.3 and earlier):**
```dart
// Positional parameters - unclear what the value represents
l10n.welcome_user('John')
l10n.item_count('5')
l10n.discount('20')
l10n.order_summary('100', '5', 'premium')  // What does each parameter mean?
```

**After (v1.0.4):**
```dart
// Named parameters - self-documenting and clear
l10n.welcome_user(name: 'John')
l10n.item_count(count: '5')
l10n.discount(value: '20')
l10n.order_summary(total: '100', items: '5', tier: 'premium')  // Crystal clear!
```

### Benefits

1. **Self-Documenting Code**
   - Parameter names are visible at call site
   - No need to check method signature to understand what each parameter does
   
2. **Prevents Parameter Order Mistakes**
   ```dart
   // Before - easy to swap parameters accidentally
   l10n.create_order('100', 'John', 'Premium')  // Which is which?
   
   // After - impossible to make order mistakes
   l10n.create_order(amount: '100', customer: 'John', tier: 'Premium')
   ```

3. **Better IDE Support**
   - Autocomplete shows parameter names
   - Easier refactoring
   - Better code navigation

4. **Future-Proof**
   - Can add optional parameters without breaking existing code
   - Easier to extend functionality

## Generated Code Example

### JSON Input:
```json
{
  "@@locale": "en",
  "greetings": {
    "welcome": "Welcome, {name}!",
    "welcome_back": "Welcome back, {name}! You have {count} new messages."
  }
}
```

### Generated Code (v1.0.4):
```dart
class _Greetings {
  _Greetings(this.locale);
  
  final Locale locale;
  
  String welcome({required String name}) {
    switch (locale.languageCode) {
      case 'en': return 'Welcome, $name!';
      case 'id': return 'Selamat datang, $name!';
      default: return 'Welcome, $name!';
    }
  }
  
  String welcome_back({required String name, required String count}) {
    switch (locale.languageCode) {
      case 'en': return 'Welcome back, $name! You have $count new messages.';
      case 'id': return 'Selamat datang kembali, $name! Anda memiliki $count pesan baru.';
      default: return 'Welcome back, $name! You have $count new messages.';
    }
  }
}
```

### Usage:
```dart
final l10n = AppLocalizations.of(context);

// Simple parameter
Text(l10n.greetings.welcome(name: 'Alice'))

// Multiple parameters
Text(l10n.greetings.welcome_back(name: 'Alice', count: '5'))
```

## Migration from v1.0.3

### Quick Steps

1. **Update Package Version**
   ```yaml
   dev_dependencies:
     localization_gen: ^1.0.4
   ```

2. **Regenerate Files**
   ```bash
   dart run localization_gen:localization_gen
   ```

3. **Update Code**
   - Convert positional to named parameters
   - Use analyzer to find all locations

4. **Test**
   ```bash
   flutter analyze
   flutter test
   ```

For detailed migration instructions, see [MIGRATION_V1.0.4.md](https://github.com/alpinnz/localization_gen/blob/master/MIGRATION_V1.0.4.md).

## Common Migration Patterns

### In Text Widgets
```dart
// Before
Text(l10n.home.welcome_user('John'))

// After
Text(l10n.home.welcome_user(name: 'John'))
```

### In Variables
```dart
// Before
final greeting = l10n.welcome('John')

// After
final greeting = l10n.welcome(name: 'John')
```

### Multiple Parameters
```dart
// Before
final message = l10n.order_info('100', '5')

// After
final message = l10n.order_info(amount: '100', quantity: '5')
```

### Dynamic Values
```dart
// Before
Text(l10n.cart_count('$itemCount'))

// After
Text(l10n.cart_count(count: '$itemCount'))
```

## Best Practices

### 1. Use Descriptive Parameter Names

```json
{
  "order": {
    "summary": "Order #{orderId} - {itemCount} items - Total: ${amount}"
  }
}
```

```dart
// Good - descriptive names
l10n.order.summary(
  orderId: '12345',
  itemCount: '3',
  amount: '100.00',
)
```

### 2. Keep Parameter Names Consistent

Use the same parameter names across different locales:

**English:**
```json
{
  "greeting": "Hello, {name}!"
}
```

**Indonesian:**
```json
{
  "greeting": "Halo, {name}!"
}
```

Both use `{name}` - this ensures consistency.

### 3. Use Meaningful Names in JSON

Choose parameter names that make sense in the context:

```json
{
  "user": {
    "profile": "Profile of {userName} - Member since {joinDate}"
  }
}
```

Not:
```json
{
  "user": {
    "profile": "Profile of {a} - Member since {b}"
  }
}
```

## FAQ

**Q: Why change from positional to named parameters?**

A: Named parameters provide better code clarity, prevent mistakes, and improve maintainability. They're especially helpful in large projects with many developers.

**Q: Do I need to update my JSON files?**

A: No, JSON files remain unchanged. Only the generated Dart code and how you call the methods change.

**Q: What if I have hundreds of calls to update?**

A: Use your IDE's find and replace feature with regex patterns. The compiler will also help you find any missed conversions.

**Q: Can I mix old and new syntax?**

A: No, once you update to v1.0.4 and regenerate, all methods will use named parameters exclusively.

**Q: Will future versions maintain this syntax?**

A: Yes, v1.0.4+ will continue using named parameters. This is the new standard going forward.

## Need Help?

- **Migration Guide:** See [MIGRATION_V1.0.4.md](https://github.com/alpinnz/localization_gen/blob/master/MIGRATION_V1.0.4.md) for detailed step-by-step instructions
- **Examples:** Check the [examples directory](https://github.com/alpinnz/localization_gen/tree/master/example) for updated code samples
- **Issues:** Open an issue on [GitHub](https://github.com/alpinnz/localization_gen/issues)
- **Documentation:** Read the [main README](https://github.com/alpinnz/localization_gen#readme) for comprehensive documentation

---

**Thank you for using localization_gen!**

We believe this change will make your codebase more maintainable and enjoyable to work with.

