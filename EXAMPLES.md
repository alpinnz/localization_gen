# Real-World Usage Examples

## Scenario 1: Login Screen

### JSON (app_en.json)
```json
{
  "@@locale": "en",
  "login": {
    "title": "Sign In",
    "subtitle": "Welcome back!",
    "email": {
      "label": "Email Address",
      "hint": "Enter your email",
      "error": {
        "empty": "Email is required",
        "invalid": "Invalid email format"
      }
    },
    "password": {
      "label": "Password",
      "hint": "Enter your password",
      "error": {
        "empty": "Password is required",
        "tooShort": "Password must be at least 6 characters"
      }
    },
    "button": "Sign In",
    "forgot": "Forgot Password?",
    "noAccount": "Don't have an account?",
    "signUp": "Sign Up"
  }
}
```

### Usage
```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login.title),
      ),
      body: Column(
        children: [
          Text(l10n.login.subtitle),
          
          TextField(
            decoration: InputDecoration(
              labelText: l10n.login.email.label,
              hintText: l10n.login.email.hint,
              errorText: hasError ? l10n.login.email.error.invalid : null,
            ),
          ),
          
          TextField(
            decoration: InputDecoration(
              labelText: l10n.login.password.label,
              hintText: l10n.login.password.hint,
            ),
          ),
          
          ElevatedButton(
            onPressed: onLogin,
            child: Text(l10n.login.button),
          ),
          
          TextButton(
            onPressed: onForgotPassword,
            child: Text(l10n.login.forgot),
          ),
          
          Row(
            children: [
              Text(l10n.login.noAccount),
              TextButton(
                onPressed: onSignUp,
                child: Text(l10n.login.signUp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Scenario 2: E-commerce App

### JSON (app_en.json)
```json
{
  "@@locale": "en",
  "product": {
    "addToCart": "Add to Cart",
    "price": "${price}",
    "discount": "{percent}% OFF",
    "stock": {
      "inStock": "In Stock",
      "outOfStock": "Out of Stock",
      "lowStock": "Only {count} left",
      "preOrder": "Pre-Order Now"
    },
    "shipping": {
      "free": "FREE Shipping",
      "estimatedArrival": "Arrives {date}",
      "express": "Express Delivery Available"
    }
  },
  "cart": {
    "title": "Shopping Cart",
    "empty": "Your cart is empty",
    "itemCount": "{count} items",
    "subtotal": "Subtotal: ${amount}",
    "shipping": "Shipping: ${amount}",
    "total": "Total: ${amount}",
    "checkout": "Proceed to Checkout"
  }
}
```

### Usage
```dart
class ProductCard extends StatelessWidget {
  final Product product;
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Card(
      child: Column(
        children: [
          Image.network(product.image),
          Text(product.name),
          Text(l10n.product.price(product.price.toString())),
          
          if (product.discount > 0)
            Text(l10n.product.discount(product.discount.toString())),
          
          // Stock status
          Text(
            product.stock > 10
                ? l10n.product.stock.inStock
                : product.stock > 0
                    ? l10n.product.stock.lowStock(product.stock.toString())
                    : l10n.product.stock.outOfStock,
          ),
          
          // Shipping info
          if (product.freeShipping)
            Text(l10n.product.shipping.free),
          
          ElevatedButton(
            onPressed: () => addToCart(product),
            child: Text(l10n.product.addToCart),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<CartItem> items;
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cart.title),
      ),
      body: items.isEmpty
          ? Center(child: Text(l10n.cart.empty))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => CartItemTile(items[index]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(l10n.cart.itemCount(items.length.toString())),
                      Text(l10n.cart.subtotal(subtotal.toString())),
                      Text(l10n.cart.shipping(shippingCost.toString())),
                      Text(l10n.cart.total(total.toString())),
                      ElevatedButton(
                        onPressed: onCheckout,
                        child: Text(l10n.cart.checkout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
```

## Scenario 3: Settings Screen

### JSON (app_en.json)
```json
{
  "@@locale": "en",
  "settings": {
    "title": "Settings",
    "account": {
      "title": "Account",
      "profile": "Edit Profile",
      "email": "Change Email",
      "password": "Change Password",
      "twoFactor": "Two-Factor Authentication",
      "deleteAccount": "Delete Account"
    },
    "preferences": {
      "title": "Preferences",
      "language": "Language",
      "theme": {
        "title": "Theme",
        "light": "Light",
        "dark": "Dark",
        "system": "System Default"
      },
      "notifications": {
        "title": "Notifications",
        "push": "Push Notifications",
        "email": "Email Notifications",
        "sms": "SMS Notifications"
      }
    },
    "privacy": {
      "title": "Privacy & Security",
      "dataSharing": "Data Sharing",
      "analytics": "Analytics",
      "crashReports": "Crash Reports"
    },
    "about": {
      "title": "About",
      "version": "Version {version}",
      "terms": "Terms of Service",
      "privacy": "Privacy Policy",
      "licenses": "Open Source Licenses"
    }
  }
}
```

### Usage
```dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings.title),
      ),
      body: ListView(
        children: [
          // Account Section
          _SectionHeader(l10n.settings.account.title),
          ListTile(
            title: Text(l10n.settings.account.profile),
            onTap: () => navigateToProfile(),
          ),
          ListTile(
            title: Text(l10n.settings.account.email),
            onTap: () => navigateToChangeEmail(),
          ),
          ListTile(
            title: Text(l10n.settings.account.password),
            onTap: () => navigateToChangePassword(),
          ),
          
          // Preferences Section
          _SectionHeader(l10n.settings.preferences.title),
          ListTile(
            title: Text(l10n.settings.preferences.language),
            subtitle: Text(currentLanguage),
            onTap: () => showLanguagePicker(),
          ),
          
          // Theme
          _SectionHeader(l10n.settings.preferences.theme.title),
          RadioListTile(
            title: Text(l10n.settings.preferences.theme.light),
            value: ThemeMode.light,
            groupValue: currentTheme,
            onChanged: (value) => setTheme(value),
          ),
          RadioListTile(
            title: Text(l10n.settings.preferences.theme.dark),
            value: ThemeMode.dark,
            groupValue: currentTheme,
            onChanged: (value) => setTheme(value),
          ),
          
          // Notifications
          _SectionHeader(l10n.settings.preferences.notifications.title),
          SwitchListTile(
            title: Text(l10n.settings.preferences.notifications.push),
            value: pushEnabled,
            onChanged: (value) => togglePush(value),
          ),
          
          // Privacy
          _SectionHeader(l10n.settings.privacy.title),
          SwitchListTile(
            title: Text(l10n.settings.privacy.analytics),
            value: analyticsEnabled,
            onChanged: (value) => toggleAnalytics(value),
          ),
          
          // About
          _SectionHeader(l10n.settings.about.title),
          ListTile(
            title: Text(l10n.settings.about.version(appVersion)),
          ),
          ListTile(
            title: Text(l10n.settings.about.terms),
            onTap: () => showTerms(),
          ),
        ],
      ),
    );
  }
}
```

## Scenario 4: Form Validation

### JSON (app_en.json)
```json
{
  "@@locale": "en",
  "validation": {
    "required": "{field} is required",
    "email": {
      "invalid": "Please enter a valid email address",
      "alreadyExists": "This email is already registered"
    },
    "password": {
      "tooShort": "Password must be at least {min} characters",
      "tooWeak": "Password must contain letters and numbers",
      "noMatch": "Passwords do not match"
    },
    "phone": {
      "invalid": "Please enter a valid phone number",
      "format": "Format: {format}"
    },
    "name": {
      "tooShort": "Name must be at least {min} characters",
      "tooLong": "Name must not exceed {max} characters"
    }
  }
}
```

### Usage
```dart
class FormValidator {
  final AppLocalizations l10n;
  
  FormValidator(this.l10n);
  
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.validation.required('Email');
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return l10n.validation.email.invalid;
    }
    return null;
  }
  
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.validation.required('Password');
    }
    if (value.length < 8) {
      return l10n.validation.password.tooShort('8');
    }
    if (!value.contains(RegExp(r'[A-Za-z]')) || !value.contains(RegExp(r'[0-9]'))) {
      return l10n.validation.password.tooWeak;
    }
    return null;
  }
  
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.validation.required('Name');
    }
    if (value.length < 2) {
      return l10n.validation.name.tooShort('2');
    }
    if (value.length > 50) {
      return l10n.validation.name.tooLong('50');
    }
    return null;
  }
}

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final validator = FormValidator(l10n);
    
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: validator.validateEmail,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            validator: validator.validatePassword,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            validator: validator.validateName,
          ),
        ],
      ),
    );
  }
}
```

## Benefits of Nested Structure

### 1. **Organization**
```dart
// Instead of:
l10n.settings_account_profile
l10n.settings_account_email
l10n.settings_preferences_language

// You get:
l10n.settings.account.profile
l10n.settings.account.email
l10n.settings.preferences.language
```

### 2. **Discoverability**
Type `l10n.settings.` and your IDE shows all settings-related translations.

### 3. **Scalability**
Easy to add new sections without cluttering the root namespace.

### 4. **Readability**
Code is self-documenting and easier to understand.

### 5. **Refactoring**
Moving or renaming sections is straightforward.

---

These examples show how the nested JSON structure makes real-world Flutter apps more maintainable and easier to work with!

