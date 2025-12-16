# Strict Validation Guide

## Overview

Strict validation ensures all your locale files have consistent translation keys and parameters. This prevents missing translations and parameter mismatches that could cause runtime errors.

## Why Use Strict Validation?

### Without Strict Validation

```json
// app_en.json
{
  "@@locale": "en",
  "welcome": "Welcome, {name}!",
  "logout": "Logout"
}

// app_id.json
{
  "@@locale": "id",
  "welcome": "Selamat datang, {user}!"
  // Missing "logout"
}
```

**Result**: Compiles successfully, but:
- Missing "logout" in Indonesian → Falls back to English
- Parameter mismatch (`{name}` vs `{user}`) → Runtime error

### With Strict Validation

Same files with `strict_validation: true`:

```
❌ LocaleValidationException: Locale has missing translation keys
  Locale: id
  Missing keys (1):
    - logout
  File: assets/localizations/app_id.json

❌ ParameterException: Parameter mismatch
  Key: welcome
  Expected parameters: name
  Actual parameters: user
```

**Result**: Build fails with clear, actionable errors before shipping!

## Quick Start

### 1. Enable Strict Validation

Add to your `pubspec.yaml`:

```yaml
localization_gen:
  input_dir: assets/localizations
  output_dir: lib/assets
  class_name: AppLocalizations
  strict_validation: true  # ← Add this line
```

### 2. Generate

```bash
dart run localization_gen
```

### 3. Fix Any Errors

The generator will show exactly what's missing or mismatched.

## What Gets Validated

### 1. Translation Keys

All locales must have identical keys.

✅ **Valid**:
```json
// app_en.json
{
  "@@locale": "en",
  "hello": "Hello",
  "goodbye": "Goodbye"
}

// app_id.json
{
  "@@locale": "id",
  "hello": "Halo",
  "goodbye": "Selamat tinggal"
}
```

❌ **Invalid** (missing key):
```json
// app_id.json - Missing "goodbye"
{
  "@@locale": "id",
  "hello": "Halo"
}
```

Error:
```
LocaleValidationException: Locale has missing translation keys
  Locale: id
  Missing keys (1):
    - goodbye
```

❌ **Invalid** (extra key):
```json
// app_id.json - Extra "welcome"
{
  "@@locale": "id",
  "hello": "Halo",
  "goodbye": "Selamat tinggal",
  "welcome": "Selamat datang"
}
```

Error:
```
LocaleValidationException: Locale has extra translation keys
  Locale: id
  Extra keys (1):
    - welcome
```

### 2. Parameter Names

Parameters must match across all locales (order-independent).

✅ **Valid** (same parameters, different order):
```json
// app_en.json
{
  "message": "Hello {name}, you have {count} items"
}

// app_id.json - Different order is OK
{
  "message": "{count} item untuk {name}"
}
```

❌ **Invalid** (different parameters):
```json
// app_en.json
{
  "greeting": "Hello {name}!"
}

// app_id.json - Uses {user} instead of {name}
{
  "greeting": "Halo {user}!"
}
```

Error:
```
ParameterException: Parameter mismatch between locales
  Key: greeting
  Expected parameters: name
  Actual parameters: user
```

### 3. Nested Structure

Validation works at all nesting levels:

✅ **Valid**:
```json
// Both files have same structure
{
  "auth": {
    "login": {
      "title": "...",
      "button": "..."
    }
  }
}
```

❌ **Invalid**:
```json
// app_en.json
{
  "auth": {
    "login": {
      "title": "Login",
      "button": "Sign In",
      "forgot": "Forgot Password"  // ← Extra in English
    }
  }
}

// app_id.json
{
  "auth": {
    "login": {
      "title": "Masuk",
      "button": "Masuk"
    }
  }
}
```

Error shows full path:
```
LocaleValidationException: Locale has missing translation keys
  Locale: id
  Missing keys (1):
    - auth.login.forgot
```

## Error Messages

### Missing Keys Error

```
LocaleValidationException: Locale has missing translation keys compared to base locale "en"
  Locale: id
  Missing keys (3):
    - auth.login.forgot_password
    - settings.theme
    - profile.edit
  File: assets/localizations/app_id.json
```

**How to Fix**: Add the missing keys to the Indonesian file.

### Extra Keys Error

```
LocaleValidationException: Locale has extra translation keys not in base locale "en"
  Locale: id
  Extra keys (2):
    - feature.new_feature
    - beta.testing
  File: assets/localizations/app_id.json
```

**How to Fix**: Either:
1. Remove extra keys from Indonesian file, OR
2. Add them to English file (if they should be there)

### Parameter Mismatch Error

```
ParameterException: Parameter mismatch between locales "en" and "id"
  Key: home.welcome_user
  Expected parameters: name
  Actual parameters: userName
  File: assets/localizations/app_id.json
```

**How to Fix**: Use the same parameter names:

```json
// app_id.json - Before
{
  "home": {
    "welcome_user": "Selamat datang, {userName}!"
  }
}

// app_id.json - After
{
  "home": {
    "welcome_user": "Selamat datang, {name}!"
  }
}
```

## Best Practices

### 1. Use From the Start

Enable strict validation when starting a new project:

```yaml
localization_gen:
  strict_validation: true
```

This prevents issues from accumulating.

### 2. Run in CI/CD

Add to your CI pipeline:

```yaml
# .github/workflows/test.yml
- name: Validate Localizations
  run: dart run localization_gen

# With strict_validation: true, this will fail if locales are inconsistent
```

### 3. Gradually Enable for Existing Projects

If you have an existing project without strict validation:

**Step 1**: Generate report without failing

```bash
# Temporarily disable strict_validation
dart run localization_gen
```

**Step 2**: Fix one locale at a time

Start with your second locale and fix all issues.

**Step 3**: Enable strict validation

Once all locales match:

```yaml
localization_gen:
  strict_validation: true
```

### 4. Parameter Naming Convention

Use consistent parameter names across all translations:

✅ **Good**:
```json
{
  "welcome": "Welcome, {userName}!",
  "greeting": "Hello, {userName}!",
  "message": "Hi {userName}, you have {itemCount} items"
}
```

❌ **Bad** (inconsistent naming):
```json
{
  "welcome": "Welcome, {name}!",
  "greeting": "Hello, {user}!",      // Different name for same concept
  "message": "Hi {n}, you have {c} items"  // Unclear names
}
```

### 5. Document Special Cases

If certain keys should differ between locales (rare), document why:

```json
{
  "@@locale": "en",
  "privacy": {
    "gdpr_notice": "GDPR compliance notice"  // EU-specific, may not apply to all locales
  }
}
```

## Integration with Watch Mode

Strict validation works seamlessly with watch mode:

```bash
dart run localization_gen --watch
```

With `strict_validation: true`:

1. Edit a JSON file
2. Save
3. Watch mode detects change
4. Regeneration runs with validation
5. Errors shown immediately in console

Example:
```
🔄 File modified: app_id.json
   Regenerating...

❌ LocaleValidationException: Locale has missing translation keys
  Locale: id
  Missing keys (1):
    - settings.theme

Fix the error, save again, and regeneration will succeed!
```

## When to Disable Strict Validation

### During Development

You might temporarily disable strict validation when:

1. **Adding new features**: Add keys to base locale first, then translate
2. **Prototyping**: Quickly test with one locale
3. **Gradual translation**: Translate incrementally

```yaml
localization_gen:
  strict_validation: false  # Temporarily disabled
```

### Production: Always Enable

For production builds, **always** enable strict validation to ensure quality.

## Migration Path

### From No Validation to Strict Validation

**Step 1**: Check current state

```bash
# Temporarily enable to see issues
# Edit pubspec.yaml: strict_validation: true
dart run localization_gen
```

You'll see all mismatches.

**Step 2**: Export current keys

Create a script to list all keys in base locale:

```bash
# Quick manual check
cat assets/localizations/app_en.json | grep -o '"[^"]*":' | sort
```

**Step 3**: Fix each locale

Go through each locale and ensure it has all keys.

**Step 4**: Verify parameters

Check that parameter names match:

```bash
# Search for parameters in all files
grep -r '{[a-zA-Z_]*}' assets/localizations/
```

**Step 5**: Enable permanently

```yaml
localization_gen:
  strict_validation: true
```

**Step 6**: Add to CI/CD

Ensure CI fails if validation fails.

## Troubleshooting

### False Positives

**Problem**: Validation reports errors for keys that look identical

**Cause**: Hidden characters, encoding issues

**Solution**:
```bash
# Check for non-visible characters
cat -A assets/localizations/app_id.json | grep "key_name"

# Re-save file with proper UTF-8 encoding
```

### Large Error Lists

**Problem**: 100+ missing keys reported

**Solution**: Fix in batches

```bash
# Get list of missing keys
dart run localization_gen 2>&1 | grep "    -" > missing_keys.txt

# Copy English values as placeholders
# Then translate in batches
```

### Parameter Order Confusion

**Problem**: Same parameters but validation fails

**Cause**: Different parameter names

**Example**:
```json
// These are DIFFERENT parameters:
"{name}"    vs   "{Name}"     // Different case
"{count}"   vs   "{cnt}"      // Different names
"{value}"   vs   "{ value }"  // Different spacing
```

**Solution**: Use exact same parameter names (case-sensitive).

## Advanced Usage

### Custom Validation Script

Create a pre-commit hook to validate before committing:

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Validating localizations..."
dart run localization_gen

if [ $? -ne 0 ]; then
  echo "❌ Localization validation failed!"
  echo "Fix errors before committing."
  exit 1
fi

echo "✅ Localization validation passed!"
```

### Automated Sync Tool

Create a tool to sync keys across locales:

```dart
// tools/sync_locales.dart
// Reads base locale and adds missing keys to other locales
// (with TODO markers for translation)
```

## Comparison

| Feature | Without Strict Validation | With Strict Validation |
|---------|--------------------------|------------------------|
| Missing keys | Silent fallback | Build error |
| Parameter mismatch | Runtime error | Build error |
| Extra keys | Ignored | Build error |
| Development speed | Faster (no checks) | Slightly slower |
| Production quality | ⚠️ Risky | ✅ Guaranteed |
| Maintenance | Harder | Easier |

## FAQ

**Q: Does strict validation slow down generation?**  
A: Minimal impact (~10-50ms for typical projects). Worth it for the safety.

**Q: Can I validate only some locales?**  
A: No, strict validation checks all locales or none. This ensures consistency.

**Q: What about locale-specific features?**  
A: Add the key to all locales. Use an empty string or placeholder in locales where it doesn't apply.

**Q: How does it work with modular files?**  
A: Validation runs after files are merged. All modular files for a locale are merged first, then validated.

**Q: Can I get a report without failing the build?**  
A: Not currently. Either enable (build fails on errors) or disable (no validation).

## Related Documentation

- [Watch Mode](WATCH_MODE.md)
- [Error Handling](README.md#error-handling)
- [Configuration](README.md#configuration-options)
- [Examples](EXAMPLES.md)

